# ruby ./lib/test/mini_test/TestNaiveHttpClient.rb
require "minitest/autorun"
require "./lib/authing_ruby.rb"
require "./lib/test/helper.rb"
require 'dotenv'
Dotenv.load('.env.test') 


class TestNaiveHttpClient < Minitest::Test

	def test_init
    naiveHttpClient = AuthingRuby::Common::NaiveHttpClient.new
	end

	def test_get
    http = AuthingRuby::Common::NaiveHttpClient.new()
    url = "https://postman-echo.com/get"
    params = {
      "a": 3
    }
    resp = http.request({
      method: 'GET',
      url: url,
      params: params,
			headers: { b: "100" },
    })
    json = JSON.parse(resp.body)
    # puts JSON.pretty_generate(json)
    assert(json.dig('args', "a") == "3")
    assert(json.dig('headers', "b") == "100")
	end

end