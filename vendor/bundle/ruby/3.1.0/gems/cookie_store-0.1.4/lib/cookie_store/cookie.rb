class CookieStore::Cookie

  QUOTED_PAIR   = "\\\\[\\x00-\\x7F]"
  LWS           = "\\r\\n(?:[ \\t]+)"
  QDTEXT        = "[\\t\\x20-\\x21\\x23-\\x3A\\x3C-\\x7E\\x80-\\xFF]|(?:#{LWS})"
  QUOTED_TEXT   = "(?:#{QUOTED_PAIR}|#{QDTEXT})*"
  IPADDR        = /\A#{URI::REGEXP::PATTERN::IPV4ADDR}\Z|\A#{URI::REGEXP::PATTERN::IPV6ADDR}\Z/
    
  TOKEN         = '[^(),\/<>@;:\\\"\[\]?={}\s]+'
  VALUE         = "(?:#{TOKEN}|#{IPADDR}|[^,;\\s]+)"
  EXPIRES_AT_VALUE = '[A-Za-z]{3},\ \d{2}[-\ ][A-Za-z]{3}[-\ ]\d{4}\ \d{2}:\d{2}:\d{2}\ (?:[A-Z]{3}|[-+]\d{4})'
  NUMERICAL_TIMEZONE = /[-+]\d{4}$/
  

  COOKIE    = /(?<name>#{TOKEN})=(?:"(?<quoted_value>#{QUOTED_TEXT})"|(?<value>#{VALUE}))(?<attributes>.*)/n
  COOKIE_AV = %r{
    ;\s+
    (?<key>#{TOKEN})
    (?:
      =
      (?:
        "(?<quoted_value>#{QUOTED_TEXT})"
        |
        (?<value>#{EXPIRES_AT_VALUE}|#{VALUE})
      )
    ){0,1}
  }nx
  COOKIES = %r{
      #{TOKEN}=(?:"#{QUOTED_TEXT}"|#{VALUE})
      (?:;\s+#{TOKEN}(?:=(?:"#{QUOTED_TEXT}"|(?:#{EXPIRES_AT_VALUE}|#{VALUE}))){0,1})*
  }nx
  

  
  # [String] The name of the cookie.
  attr_reader :name
  
  # [String] The value of the cookie, without any attempts at decoding.
  attr_reader :value
  
  # [String] The domain scope of the cookie. Follows the RFC 2965
  # 'effective host' rules. A 'dot' prefix indicates that it applies both
  # to the non-dotted domain and child domains, while no prefix indicates
  # that only exact matches of the domain are in scope.
  attr_reader :domain
  
  # [String] The path scope of the cookie. The cookie applies to URI paths
  # that prefix match this value.
  attr_reader :path
  
  # [Boolean] The secure flag is set to indicate that the cookie should
  # only be sent securely. Nearly all HTTP User Agent implementations assume
  # this to mean that the cookie should only be sent over a
  # SSL/TLS-protected connection
  attr_reader :secure
  
  # [Boolean] Popular browser extension to mark a cookie as invisible
  # to code running within the browser, such as JavaScript
  attr_reader :http_only
  
  # [Fixnum] Version indicator, currently either
  # * 0 for netscape cookies
  # * 1 for RFC 2965 cookies
  attr_reader :version
  
  # [String, nil] RFC 2965 field for indicating comment (or a location)
  # describing the cookie to a usesr agent.
  attr_reader :comment, :comment_url
  
  # [Boolean] RFC 2965 field for indicating session lifetime for a cookie
  attr_reader :discard
  
  # [Array<FixNum>, nil] RFC 2965 port scope for the cookie. If not nil,
  # indicates specific ports on the HTTP server which should receive this
  # cookie if contacted.
  attr_reader :ports

  # [DateTime] The Expires directive tells the browser when to delete the cookie.
  # Derived from the format used in RFC 1123
  attr_reader :expires
  
  # [Fixnum] RFC 6265 allows the use of the Max-Age attribute to set the
  # cookie’s expiration as an interval of seconds in the future, relative
  # to the time the browser received the cookie.
  attr_reader :max_age
  
  # [Time] Time when this cookie was first evaluated and created.
  attr_reader :created_at
  
  def initialize(name, value, options={})
    @name = name
    @value = value
    @secure = false
    @http_only = false
    @version = 1
    @discard = false
    @created_at = Time.now
    
    options.each do |attr_name, attr_value|
      self.instance_variable_set(:"@#{attr_name}", attr_value)
    end
  end
  
  # Evaluate when this cookie will expire. Uses the original cookie fields
  # for a max-age or expires
  #
  # @return [Time, nil] Time of expiry, if this cookie has an expiry set
  def expires_at
    if max_age
      created_at + max_age
    else
      expires
    end
  end
  
  # Indicates whether the cookie is currently considered valid
  #
  # @return [Boolean]
  def expired?
    expires_at && Time.now > expires_at
  end
  
  # Indicates whether the cookie will be considered invalid after the end
  # of the current user session
  # @return [Boolean]
  def session?
    !expires_at || discard
  end
  
  def to_s
    if value.include?('"')
      "#{name}=\"#{value.gsub('"', '\\"')}\""
    else
      "#{name}=#{value}"
    end
  end
  
  # Returns a true if the request_uri is a domain-match, a path-match, and a 
  # port-match
  def request_match?(request_uri)
    uri = request_uri.is_a?(URI) ? request_uri : URI.parse(request_uri)
    domain_match(uri.host) && path_match(uri.path) &&  port_match(uri.port)
  end
  
  # From RFC2965 Section 1.
  #
  # For two strings that represent paths, P1 and P2, P1 path-matches P2
  # if P2 is a prefix of P1 (including the case where P1 and P2 string-
  # compare equal).  Thus, the string /tec/waldo path-matches /tec.
  def path_match(request_path)
    request_path.start_with?(path)
  end

  # From RFC2965 Section 1.
  #
  # Host A's name domain-matches host B's if
  #
  # *  their host name strings string-compare equal; or
  #
  # * A is a HDN string and has the form NB, where N is a non-empty
  #   name string, B has the form .B', and B' is a HDN string.  (So,
  #   x.y.com domain-matches .Y.com but not Y.com.)
  def domain_match(request_domain)
    request_domain = request_domain.downcase

    return true if domain == request_domain
    
    return false if request_domain =~ IPADDR
    
    return true if domain == ".#{request_domain}"
    
    return false if !domain.include?('.') && domain != 'local'
    
    return false if !request_domain.end_with?(domain)

    return !(request_domain[0...-domain.length].count('.') > (request_domain[-domain.length-1] == '.' ? 1 : 0))
  end
  
  # From RFC2965 Section 3.3 
  #
  # The default behavior is that a cookie MAY be returned to any request-port.
  #
  # If the port attribute is set the port must be in the port-list.
  def port_match(request_port)
    return true unless ports
    ports.include?(request_port)
  end
  
  def self.parse_cookies(request_uri, set_cookie_value)
    uri = request_uri.is_a?(URI) ? request_uri : URI.parse(request_uri)
    cookies = []
    set_cookie_value.scan(COOKIES) do |cookie|
      cookies << parse(uri, cookie)
    end
    cookies
  end
  
  def self.parse(request_uri, set_cookie_value)
    uri = request_uri.is_a?(URI) ? request_uri : URI.parse(request_uri)
    data = COOKIE.match(set_cookie_value)
    options = {}
    
    if !data
      raise Net::HTTPHeaderSyntaxError.new("Invalid Set-Cookie header format")
    end
    
    if data[:attributes]
      data[:attributes].scan(COOKIE_AV) do |key, quoted_value, value|
        value = quoted_value.gsub(/\\(.)/, '\1') if !value && quoted_value

        # RFC 2109 4.1, Attributes (names) are case-insensitive
        case key.downcase
        when 'comment'
          options[:comment] = value
        when 'commenturl'
          options[:comment_url] = value
        when 'discard'
          options[:discard] = true
        when 'domain'
          if value =~ IPADDR
            options[:domain] = value
          else
            # As per RFC2965 if a host name contains no dots, the effective host name is
            # that name with the string .local appended to it.
            value = "#{value}.local" if !value.include?('.')
            options[:domain] = (value.start_with?('.') ? value : ".#{value}").downcase
          end
        when 'expires'
          if value.include?('-') && !value.match(NUMERICAL_TIMEZONE)
            options[:expires] = DateTime.strptime(value, '%a, %d-%b-%Y %H:%M:%S %Z')
          else
            options[:expires] = DateTime.strptime(value, '%a, %d %b %Y %H:%M:%S %Z')
          end
        when 'max-age'
          options[:max_age] = value.to_i
        when 'path'
          options[:path] = value
        when 'port'
          options[:ports] = value.split(',').map(&:to_i)
        when 'secure'
          options[:secure] = true
        when 'httponly'
          options[:http_only] = true
        when 'version'
          options[:version] = value.to_i
        end
      end
    end
    options[:domain]  ||= uri.host.downcase
    options[:path]    ||= uri.path
    
    CookieStore::Cookie.new(data[:name], data[:value] || data[:quoted_value].gsub(/\\(.)/, '\1'), options)
  end
    
end
