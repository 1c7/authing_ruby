require "minitest/autorun" # Minitest
require "./lib/authing_ruby.rb" # 模块主文件
require "./lib/test/helper.rb" # 模块主文件
require 'dotenv' # 载入环境变量文件
Dotenv.load('.env.test') # 你可以编辑这个文件来修改环境变量

class TestManagementClient < Minitest::Test
	
	def setup
	end

	# 测试创建用户
	# TODO
	def test_users_create
		options = {
      userPoolId: ENV["userPoolId"],
      secret: ENV["secret"],
    }
		managementClient = AuthingRuby::ManagementClient.new(options)
    managementClient.users.create({
			username: 'bob',
			password: 'passw0rd',
		})
	end

end