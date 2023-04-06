require 'test_helper'

class CookieStore::HashStoreTest < Minitest::Test

  test "#cookies_for" do
    store = CookieStore::HashStore.new
    
    store.add(CookieStore::Cookie.new('a','value', :domain => 'google.com', :path => '/'))
    store.add(CookieStore::Cookie.new('b','value', :domain => '.google.com', :path => '/'))
    store.add(CookieStore::Cookie.new('c','value', :domain => 'www.google.com', :path => '/'))
    store.add(CookieStore::Cookie.new('d','value', :domain => 'random.com', :path => '/'))
    
    store.add(CookieStore::Cookie.new('e','value', :domain => '.google.com', :path => '/'))
    store.add(CookieStore::Cookie.new('f','value', :domain => '.google.com', :path => '/test'))
    
    store.add(CookieStore::Cookie.new('g','value', :domain => '.google.com', :path => '/', :max_age => 3660))
    store.add(CookieStore::Cookie.new('h','value', :domain => '.google.com', :path => '/', :max_age => 0))
    
    store.add(CookieStore::Cookie.new('i','value', :domain => '.google.com', :path => '/', :ports => [80,8080]))
    store.add(CookieStore::Cookie.new('j','value', :domain => '.google.com', :path => '/', :ports => [80,8080], :secure => true))
    
    store.add(CookieStore::Cookie.new('k','value', :domain => '.google.com', :path => '/', :secure => true))
    
    assert_equal %w(a b e g i), store.cookies_for('http://google.com/').map(&:name).sort
    assert_equal %w(b e g i), store.cookies_for('http://test.google.com/').map(&:name).sort
    assert_equal %w(b c e g i), store.cookies_for('http://www.google.com/').map(&:name).sort
    
    assert_equal %w(b c e g i), store.cookies_for('http://www.google.com/rest').map(&:name).sort
    assert_equal %w(b c e f g i), store.cookies_for('http://www.google.com/test').map(&:name).sort
    
    assert_equal %w(b c e f g k), store.cookies_for('https://www.google.com/test').map(&:name).sort
  end
  
  test '#cookies_for removes expired cookies while iterating' do
    store = CookieStore::HashStore.new
    store.expects(:gc).once
    
    store.add(CookieStore::Cookie.new('h','value', :domain => '.google.com', :path => '/', :max_age => 0))
    store.cookies_for('http://google.com/')
  end
  
  test '#gc clears out expired cookies' do
    store = CookieStore::HashStore.new
    
    store.add(CookieStore::Cookie.new('h','value', :domain => '.google.com', :path => '/', :max_age => 0))
    store.gc
    assert_equal({}, store.instance_variable_get(:@domains))
    
    store.add(CookieStore::Cookie.new('h','value', :domain => '.google.com', :path => '/', :max_age => 0))
    store.add(CookieStore::Cookie.new('h','value', :domain => '.google.com', :path => '/'))
    store.gc
    assert_equal 1, store.instance_variable_get(:@domains).size
    assert_equal 1, store.instance_variable_get(:@domains)['.google.com'].size
    assert_equal 1, store.instance_variable_get(:@domains)['.google.com']['/'].size
  end
  
  test "#gc doesn't clears out session cookies when not out the session" do
    store = CookieStore::HashStore.new
    
    store.add(CookieStore::Cookie.new('h','value', :domain => '.google.com', :path => '/', :max_age => 0))
    store.add(CookieStore::Cookie.new('h','value', :domain => '.google.com', :path => '/', :discard => true))
    
    store.gc
    assert_equal 1, store.instance_variable_get(:@domains).size
    assert_equal 1, store.instance_variable_get(:@domains)['.google.com'].size
    assert_equal 1, store.instance_variable_get(:@domains)['.google.com']['/'].size
  end
  
  test '#gc clears out session cookies when closing out the session' do
    store = CookieStore::HashStore.new
    
    store.add(CookieStore::Cookie.new('h','value', :domain => '.google.com', :path => '/', :discard => true))
    
    store.gc(true)
    assert_equal({}, store.instance_variable_get(:@domains))
  end
  
end