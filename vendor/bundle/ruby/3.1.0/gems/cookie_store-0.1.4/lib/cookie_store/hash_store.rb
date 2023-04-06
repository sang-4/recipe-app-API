class CookieStore::HashStore < CookieStore

  def initialize
    @domains = {}
  end

  def add(cookie)
    #TODO: check for MAX_COOKIES_PER_DOMAIN && MAX_COOKIES_TOTAL, think remove the MAX_COOKIES_TOTAL tho
    @domains[cookie.domain] ||= {}
    @domains[cookie.domain][cookie.path] ||= {}
    @domains[cookie.domain][cookie.path][cookie.name] = cookie
  end

  def cookies_for(request_uri)
    request_uri = URI.parse(request_uri)
    trigger_gc = false
    request_cookies = []
    
    search_domains_for(request_uri.host).each do |domain|
      next unless @domains[domain]
      
      @domains[domain].each do |path, cookies|
        if request_uri.path.start_with?(path)
          cookies.each do |name, cookie|
            if cookie.expired?
              trigger_gc = true
            elsif cookie.port_match(request_uri.port) && (!cookie.secure || (cookie.secure && request_uri.scheme == 'https'))
              request_cookies << cookie
            end
          end
        end
      end
    end
    
    gc if trigger_gc
    
    request_cookies
  end
  
  def gc(close_session=false)
    @domains.delete_if do |domain, paths|
      paths.delete_if do |path, cookies|
        cookies.delete_if do |cookie_name, cookie|
          cookie.expired? || (close_session && cookie.session?)
        end
        cookies.empty?
      end
      paths.empty?
    end
  end

end