# 测试 lib/common/HttpClient.rb
# 运行: ruby ./lib/test/mini_test/TestHttpClient.rb

require "minitest/autorun"
require './lib/common/HttpClient.rb'

class TestAuthenticationClient < Minitest::Test

  # 测试初始化，初始化不应该报错
  def test_init
    httpClient = AuthingRuby::Common::HttpClient.new
  end
  
  # 测试简单的 get 方法
  # ruby ./lib/test/mini_test/TestHttpClient.rb -n test_get
  def test_get
    httpClient = AuthingRuby::Common::HttpClient.new
    url = "https://postman-echo.com/get"
    # url = "https://postman-echo.com/get?foo1=bar1&foo2=bar2"
    params = {
      "a": 3,
      "b": 4,
    }
    resp = httpClient.request({
      method: 'GET',
      url: url,
      params: params,
    })
    json = JSON.parse(resp.body)
    # puts JSON.pretty_generate(json)
    assert(json.dig('args', "a") == "3")
  end

  # 测试 post 方法
  # ruby ./lib/test/mini_test/TestHttpClient.rb -n test_post
  def test_post
    httpClient = AuthingRuby::Common::HttpClient.new
    url = "https://postman-echo.com/post"
    resp = httpClient.request({
      method: 'POST',
      url: url,
      data: {
        "x": 100,
        "y": 200,
      }
    })
    json = JSON.parse(resp.body)
    # puts JSON.pretty_generate(json)
    assert(json.dig('json', "x") == "100")
  end


end