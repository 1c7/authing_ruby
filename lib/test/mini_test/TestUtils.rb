# ruby ./lib/test/mini_test/TestUtils.rb

require "minitest/autorun" 
require "./lib/authing_ruby.rb"
require "./lib/test/helper.rb" 
require 'dotenv'
Dotenv.load('.env.test') 


class TestUtils < Minitest::Test

	# 测试生成随机字符串
	def test_randomString()
		random = AuthingRuby::Utils.generateRandomString(43)
		# puts random
		assert(random.length == 43)
	end

end