# 测试 lib/common/HttpClient.rb
# 运行: ruby ./lib/test/mini_test/TestHttpClient.rb

require "minitest/autorun" # Minitest
require './lib/common/HttpClient.rb'


class TestAuthenticationClient < Minitest::Test
  def setup
	end

	# 测试初始化，初始化不应该报错
	def test_init
		httpClient = Common::HttpClient.new
	end
	
	# 测试简单的 get 方法
	def test_get
		httpClient = Common::HttpClient.new
		url = "https://postman-echo.com/get"
		# url = "https://postman-echo.com/get?foo1=bar1&foo2=bar2"
		resp = httpClient.request({
			method: 'GET',
			url: url,
			params: {
				"a": 3,
				"b": 4,
			}
		})
		json = JSON.parse(resp.body)
		puts JSON.pretty_generate(json)
	end

	# 测试 post 方法
	def test_post
		httpClient = Common::HttpClient.new
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
		puts JSON.pretty_generate(json)
	end


end