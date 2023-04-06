require 'test_helper'

class CookieStore::CookieTest < Minitest::Test

  # CookieStore::Cookie.new ================================================================
  
  test "::new(name, value)" do
    cookie = CookieStore::Cookie.new('foo', 'bar')

    assert_equal 'foo', cookie.name
    assert_equal 'bar', cookie.value
  end
  
  test "::new(name, value, options)" do
    #TODO: test all options are set
    cookie = CookieStore::Cookie.new('foo', 'bar', :domain => 'test.com')

    assert_equal 'test.com', cookie.domain
  end
  
  # CookieStore::Cookie.domain_match =======================================================

  test "::domain_match(request_domain)" do
    {
      'a.com'                     => 'a.com',
      'test.com'                  => '.test.com',
      '123.456.57.21'             => '123.456.57.21'
      #TODO: not sure how ipv6 works '[E3D7::51F4:9BC8:C0A8:6420]' => '[E3D7::51F4:9BC8:C0A8:6420]'
    }.each do |host, cookie_host|
      cookie = CookieStore::Cookie.new('key', 'value', :domain => cookie_host)
      assert_equal true, cookie.domain_match(host)
    end
    
    {
      'a.com'                     => 'b.com',
      'test.com'                  => '.com',
      'test.com'                  => '.com.',
      'test.com'                  => 'com',
      'test.com'                  => 'com.',
      'y.x.foo.com'               => '.foo.com',
      'y.x.foo.com'               => 'foo.com',
      '123.456.57.21'             => '123.456.57.22',
      '123.456.57.21'             => '.123.456.57.21'
      #TODO: not sure how ipv6 works '[E3D7::51F4:9BC8:C0A8:6420]' => '[E3D7::51F4:9BC8:C0A8:6421]'
    }.each do |host, cookie_host|
      cookie = CookieStore::Cookie.new('key', 'value', :domain => cookie_host)
      assert_equal false, cookie.domain_match(host)
    end
  end
  
  # CookieStore::Cookie.path_match =========================================================
  
  test "::path_match(request_path)" do
    {
      '/test'                     => '/',
      '/this/is/my/url'           => '/this/is'
    }.each do |path, cookie_path|
      cookie = CookieStore::Cookie.new('key', 'value', :path => cookie_path)
      assert_equal true, cookie.path_match(path)
    end
    
    {
      '/test'                     => '/rest',
      '/'                         => '/test'
    }.each do |path, cookie_path|
      cookie = CookieStore::Cookie.new('key', 'value', :path => cookie_path)
      assert_equal false, cookie.path_match(path)
    end
  end
  
  # CookieStore::Cookie.port_match =========================================================
  
  test "::port_match(request_port) without ports attribute set" do
    cookie = CookieStore::Cookie.new('key', 'value')
    assert_equal true, cookie.port_match(158)
  end
  
  test "::port_match(request_port) with ports attribute set" do
    cookie = CookieStore::Cookie.new('key', 'value', :ports => [80, 8700])
    assert_equal true, cookie.port_match(8700)
    assert_equal false, cookie.port_match(87)
  end
  
  # CookieStore::Cookie.expires_at =========================================================
  
  test "#expires_at based on max-age" do
    travel_to Time.new(2013, 12, 13, 8, 26, 12, 0) do
      cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Max-Age=3600')
      assert_equal Time.new(2013, 12, 13, 9, 26, 12, 0), cookie.expires_at
    end
  end
  
  test "#expires_at based on expires attribute" do
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Expires="Wed, 13 Jan 2021 22:23:01 GMT"')
    assert_equal DateTime.new(2021, 1, 13, 22, 23, 1, 0), cookie.expires_at
  end
  
  test "#expires_at perfers max-age to expires" do
    travel_to Time.new(2013, 12, 13, 8, 26, 12, 0) do
      cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Max-Age=3600 Expires="Wed, 13 Jan 2021 22:23:01 GMT"')
      assert_equal Time.new(2013, 12, 13, 9, 26, 12, 0), cookie.expires_at
    end
  end
  
  test "#expires_at returns nil if no max-age or expires attribute" do
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar')
    assert_equal nil, cookie.expires_at
  end
  
  # CookieStore::Cookie.expired? =========================================================
  
  test "#expired?" do
    cookie = travel_to Time.new(2013, 12, 13, 8, 26, 12, 0) do
      CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Max-Age=3600')
    end
    
    assert_equal true, cookie.expired?

    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Max-Age=3600')
    assert_equal false, cookie.expired?
  end
  
  # CookieStore::Cookie.session? ===========================================================
  
  test "#session? true by default" do
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar')
    assert_equal true, cookie.session?
  end
  
  test "#session? false if on expiration" do
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Max-Age=3600')
    assert_equal false, cookie.session?
  end
  
  test "#session? true if discard attribute is present" do
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Max-Age=3600; Discard')
    assert_equal true, cookie.session?
        
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Discard')
    assert_equal true, cookie.session?
  end
  
  # CookieStore::Cookie.to_s ===============================================================
  
  test "#to_s" do
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar')
    assert_equal "foo=bar", cookie.to_s
  end
  
  test "#to_s with a \" in the value" do
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo="ba\"r"')
    assert_equal "foo=\"ba\\\"r\"", cookie.to_s
  end
  
  #TODO: # CookieStore::Cookie.to_h ===============================================================
  #
  # test "#to_h" do
  #   cookie = travel_to Time.new(2013, 12, 13, 8, 26, 12, 0) do
  #     CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Max-Age=3600; Discard')
  #   end
  #
  #   assert_equal({
  #     :name     => 'foo',
  #     :value    => 'bar',
  #     :domain   => 'google.com',
  #     :path     => '/test/this',
  #     :secure   => false,
  #     :http_only => false,
  #     :version   => 1,
  #     :comment   => nil,
  #     :comment_url => nil,
  #     :discard     => true,
  #     :ports        => nil,
  #     :expires      => nil,
  #     :max_age      => 3600,
  #     :created_at   => Time.new(2013, 12, 13, 8, 26, 12, 0)
  #   }, cookie.to_h)
  # end
  
  # CookieStore::Cookie.parse ==============================================================
  
  test "::parse a simple cookie" do
    cookie = CookieStore::Cookie.parse('http://google.com/test', "foo=bar")

    assert_equal 'foo',         cookie.name
    assert_equal 'bar',         cookie.value
    assert_equal 'google.com',  cookie.domain
    assert_equal '/test',       cookie.path
    assert_equal false,         cookie.secure
    assert_equal false,         cookie.http_only
    assert_equal nil,           cookie.comment
    assert_equal nil,           cookie.comment_url
    assert_equal 1,             cookie.version
    assert_equal false,         cookie.discard
    assert_equal nil,           cookie.ports
    assert_equal nil,           cookie.expires
    assert_equal nil,           cookie.max_age
  end
  
  test "::parse a cookie with options" do
    cookie = CookieStore::Cookie.parse('http://google.com/test', "foo=bar; path=/; HttpOnly")

    assert_equal 'foo',         cookie.name
    assert_equal 'bar',         cookie.value
    assert_equal 'google.com',  cookie.domain
    assert_equal '/',           cookie.path
    assert_equal false,         cookie.secure
    assert_equal true,          cookie.http_only
    assert_equal nil,           cookie.comment
    assert_equal nil,           cookie.comment_url
    assert_equal 1,             cookie.version
    assert_equal false,         cookie.discard
    assert_equal nil,           cookie.ports
    assert_equal nil,           cookie.expires
    assert_equal nil,           cookie.max_age
  end

  test "::parse normalizes the request domain" do
    cookie = CookieStore::Cookie.parse('http://GoOGlE.com/test', "foo=bar")
    assert_equal 'google.com',  cookie.domain
  end
  
  test "::parse parth with a ? at the end" do
    cookie = CookieStore::Cookie.parse('http://GoOGlE.com/test?key=value', "foo=bar")
    assert_equal '/test',  cookie.path
  end
  
  
  test "::parse parth with a # at the end" do
    cookie = CookieStore::Cookie.parse('http://GoOGlE.com/test#anchor', "foo=bar")
    assert_equal '/test',  cookie.path
  end
  
  test "::parse a simple quoted cookie" do
    cookie = CookieStore::Cookie.parse('http://google.com/test', 'foo="b\"ar"')

    assert_equal 'google.com', cookie.domain
    assert_equal 'foo', cookie.name
    assert_equal 'b"ar', cookie.value
  end
  
  test "::parse domain attribute without leading ." do
    cookie = CookieStore::Cookie.parse('http://google.com/test', "foo=bar; Domain=google.com")
    assert_equal '.google.com', cookie.domain
  end

  test "::parse domain attribute with leading ." do
    cookie = CookieStore::Cookie.parse('http://google.com/test', "foo=bar; Domain=.google.com")
    assert_equal '.google.com', cookie.domain
  end
  
  test "::parse domain attribute that is the superdomain" do
    cookie = CookieStore::Cookie.parse('http://site.google.com/test', "foo=bar; Domain=google.com")
    assert_equal '.google.com', cookie.domain
  end
  
  test "::parse domain attribute as ip" do
    cookie = CookieStore::Cookie.parse('http://123.456.57.21/test', "foo=bar; Domain=123.456.57.21")

    assert_equal '123.456.57.21', cookie.domain
  end
  
  test "::parse path attribute" do
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Path="/"')
    
    assert_equal '/', cookie.path
  end
  
  test "::parse secure attribute" do
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Secure')
    assert_equal true, cookie.secure
  end
  
  test "::parse http_only attribute" do
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; HttpOnly')
    assert_equal true, cookie.http_only
  end
  
  test "::parse comment attribute" do
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Comment="the c\"omment"')
    assert_equal 'the c"omment', cookie.comment
  end
  
  test "::parse coment_url attribute" do
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; CommentURL="http://google.com/url"')
    assert_equal "http://google.com/url", cookie.comment_url
  end
  
  test "::parse version attribute" do
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Version=0')
    assert_equal 0, cookie.version
  end
  
  test "::parse discard attribute" do
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Discard')
    assert_equal true, cookie.discard
  end
  
  test "::parse port attribute" do
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Port="80"')
    assert_equal [80], cookie.ports
    
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Port="80,8080"')
    assert_equal [80, 8080], cookie.ports
  end

  test "::parse expires attribute" do
    # Wed, 13 Jan 2021 22:23:01 GMT format
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Expires=Wed, 13 Jan 2021 22:23:01 GMT')
    assert_equal DateTime.new(2021, 1, 13, 22, 23, 1, 0), cookie.expires
    
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Expires="Wed, 13 Jan 2021 22:23:01 GMT"')
    assert_equal DateTime.new(2021, 1, 13, 22, 23, 1, 0), cookie.expires
    
    # Wed, 13-Jan-2021 22:23:01 GMT format
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Expires=Wed, 13-Jan-2021 22:23:01 GMT')
    assert_equal DateTime.new(2021, 1, 13, 22, 23, 1, 0), cookie.expires
    
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Expires="Wed, 13-Jan-2021 22:23:01 GMT"')
    assert_equal DateTime.new(2021, 1, 13, 22, 23, 1, 0), cookie.expires

    # Wed, 13 Jan 2021 22:23:01 -0000 format
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Expires=Wed, 13 Jan 2021 22:23:01 -0000')
    assert_equal DateTime.new(2021, 1, 13, 22, 23, 1, 0), cookie.expires

    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Expires="Wed, 13 Jan 2021 22:23:01 +0000"')
    assert_equal DateTime.new(2021, 1, 13, 22, 23, 1, 0), cookie.expires
  end
  
  test "::parse max_age attribute" do
    cookie = CookieStore::Cookie.parse('http://google.com/test/this', 'foo=bar; Max-Age=3660')
    assert_equal 3660, cookie.max_age
  end

  test "::parse_cookies with one cookie" do
    cookies = CookieStore::Cookie.parse_cookies("http://google.com/test/this", "current_account_id=2449; path=/")

    assert_equal "current_account_id",  cookies.first.name
    assert_equal "2449",                cookies.first.value
    assert_equal "/",                   cookies.first.path
  end
    
  test "::parse_cookies with multiple cookies" do
    cookies = CookieStore::Cookie.parse_cookies("http://google.com/test/this", "current_account_id=2449; path=/, _session=QUZwVE5jNjB; path=/test; expires=Wed, 13-Jan-2021 22:23:01 GMT; HttpOnly")

    assert_equal "current_account_id",  cookies.first.name
    assert_equal "2449",                cookies.first.value
    assert_equal "/",                   cookies.first.path
    
    assert_equal "_session",            cookies[1].name
    assert_equal "QUZwVE5jNjB",         cookies[1].value
    assert_equal "/test",               cookies[1].path
    assert_equal DateTime.new(2021, 1, 13, 22, 23, 1, 0), cookies[1].expires
    assert_equal true,                  cookies[1].http_only
  end
  
  # TODO: test expires_at, based on expires attribute
  # TODO: test expires_at, based on max-age attribute
  
end