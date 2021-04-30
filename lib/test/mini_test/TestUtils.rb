# ruby ./lib/test/mini_test/TestUtils.rb

require "minitest/autorun" 
require "./lib/authing_ruby.rb"
require "./lib/test/helper.rb" 
require 'dotenv'
Dotenv.load('.env.test') 


class TestUtils < Minitest::Test

	# 测试生成随机字符串
	def test_randomString
		random = AuthingRuby::Utils.generateRandomString(43)
		assert(random.length == 43)
	end

	def test_randomNumberString
		random = AuthingRuby::Utils.randomNumberString(10)
		assert(random.length == 10)
	end

	def test_hash_each
		hash = {
			a:1,
			b:2,
		}
		hash.each do |key, value|
			puts "key: #{key}"
			puts "value: #{value}"
			puts "---"
		end
	end

end