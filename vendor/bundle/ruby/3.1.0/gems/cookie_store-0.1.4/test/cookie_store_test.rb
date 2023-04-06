require 'test_helper'

class CookieStoreTest < Minitest::Test
  
  # Cookie.set_cookie =========================================================
  
  test "#set_cookie" do
    store = CookieStore.new
    store.expects(:add).times(3)
    
    store.set_cookie('http://google.com/test/this', 'foo=bar; Max-Age=3600')
    store.set_cookie('http://localhost/test/this', 'foo=bar; Max-Age=3600')
    store.set_cookie('http://127.0.0.1/test/this', 'foo=bar; Max-Age=3600')
  end
  
  test "#set_cookie contains multiple cookies" do
    store = CookieStore.new
    store.expects(:add).times(2)
    
    store.set_cookie("http://google.com/test/this", "current_account_id=2449; path=/, _session=QUZwVE5jNjB; path=/test; expires=Wed, 13-Jan-2021 22:23:01 GMT; HttpOnly")
  end
  
  test "#set_cookie rejects cookies where the value for the Domain attribute contains no embedded dots" do
    store = CookieStore.new
    store.expects(:add).never
    
    store.set_cookie('http://google.com/test', 'foo=bar; Domain=com')
    store.set_cookie('http://google.com/test', 'foo=bar; Domain=.com')
    store.set_cookie('http://google.com/test', 'foo=bar; Domain=com.')
    store.set_cookie('http://google.com/test', 'foo=bar; Domain=.com.')
  end
  
  test "#set_cookie rejects cookies that do not domain-match" do
    store = CookieStore.new
    store.expects(:add).never
    
    store.set_cookie('http://google.com/test', 'foo=bar; Domain=gobble.com')
    store.set_cookie('http://y.x.foo.com/test', 'foo=bar; Domain=.foo.com')
    store.set_cookie('http://y.x.foo.com/test', 'foo=bar; Domain=foo.com')
    store.set_cookie('http://123.456.57.21/test', 'foo=bar; Domain=123.456.57.22')
    store.set_cookie('http://123.456.57.21/test', 'foo=bar; Domain=.123.456.57.21')
    #TODO: not sure how ipv6 works '' => '[E3D7::51F4:9BC8:C0A8:6421]'
  end
  
  test "#set_cookie rejects cookies that do not path-match" do
    store = CookieStore.new
    store.expects(:add).never
    
    store.set_cookie('http://google.com/test', 'foo=bar; Path=/text')
    store.set_cookie('http://google.com/test', 'foo=bar; Path=/test/mykey')
  end
  
  test "#set_cookie rejects cookies that do not port-match" do
    store = CookieStore.new
    store.expects(:add).never
    
    store.set_cookie('http://google.com:97/test', 'foo=bar; Port="80,8080"')
  end
  
  test "#set_cookie rejects cookies that are over the byte limit" do
    store = CookieStore.new
    store.expects(:add).never
    
    store.set_cookie('http://google.com/test', "foo=#{'k'*(CookieStore::MAX_COOKIE_LENGTH-3)}; Max-Age=3600")
  end
  
  test "#search_domains_for" do
    store = CookieStore.new
    
    assert_equal ['google.com', '.google.com'],                         store.search_domains_for('google.com')
    assert_equal ["www.google.com", ".www.google.com", ".google.com"],  store.search_domains_for('www.google.com')
    assert_equal ["com.local", ".com.local"],                           store.search_domains_for('com')
    assert_equal ["123.456.57.22"],                                     store.search_domains_for('123.456.57.22')
    #TODO: not sure about ipv6 assert_equal ["com.local", ".com.local"],                           store.search_domains_for('[E3D7::51F4:9BC8:C0A8:6420]')
  end
  
  test "#close_session calls gc(true)" do
    store = CookieStore.new
    store.expects(:gc).with(true).once
    
    store.close_session
  end
  
  test "#cookie_header_for" do
    store = CookieStore.new
    
    store.expects(:cookies_for).with('url').returns([CookieStore::Cookie.new('key', 'value')])
    assert_equal 'key=value', store.cookie_header_for('url')
    
    store.expects(:cookies_for).with('url').returns([CookieStore::Cookie.new('key', 'value'), CookieStore::Cookie.new('foo', 'bar')])
    assert_equal 'key=value; foo=bar', store.cookie_header_for('url')
    
    store.expects(:cookies_for).with('url').returns([CookieStore::Cookie.new('key', 'v"alue')])
    assert_equal 'key="v\"alue"', store.cookie_header_for('url')
  end
  
end