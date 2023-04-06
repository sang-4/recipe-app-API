require 'uri'

class CookieStore
  
  # Maximum number of bytes per cookie (RFC 6265 6.1 requires at least 4096)
  MAX_COOKIE_LENGTH = 4096
  
  # Maximum number of cookies per domain (RFC 6265 6.1 requires 50 at least)
  MAX_COOKIES_PER_DOMAIN = 50
  
  # Maximum number of cookies total (RFC 6265 6.1 requires 3000 at least)
  MAX_COOKIES_TOTAL = 3000
  
  # Read and set the cookie from the Set-Cookie header
  def set_cookie(request_uri, set_cookie_value)
    request_uri = URI.parse(request_uri)
    
    CookieStore::Cookie.parse_cookies(request_uri, set_cookie_value).each do |cookie|
      # reject as per RFC2965 Section 3.3.2
      return if !cookie.request_match?(request_uri) || !(cookie.domain =~ /.+\..+/ || cookie.domain == 'localhost')
    
      # reject cookies over the max-bytes
      return if cookie.to_s.size > MAX_COOKIE_LENGTH
    
      add(cookie) 
    end
  end
  
  def cookie_header_for(request_uri)
    cookies_for(request_uri).map(&:to_s).join('; ')
  end
  
  # (RFC 2965, section 1)
  def search_domains_for(domain)
    domain.downcase!
    serach_domains = []
    
    if domain =~ CookieStore::Cookie::IPADDR
      serach_domains << domain
    else
      domain = domain + '.local' if !(domain =~ /.\../)
      serach_domains << domain
      serach_domains << ".#{domain}"
      
      # H is the host domain name of a host; and,
      # H has the form A.B; and
      if domain =~ /[^\.]+(\..+)/
        reach = $1
        # B has at least one embedded dot
        if reach =~ /.[\.:]./
          # B has at least one embedded dot, or B is the string "local".
          # then the reach of H is .B.
          serach_domains << reach
        end
      end
    end
    
    serach_domains
  end
  
  def close_session
    gc(true)
  end
  
end

require 'cookie_store/cookie'
require 'cookie_store/hash_store'