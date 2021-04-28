# ruby ./lib/test/mini_test/TestManagementClient.rb

require "minitest/autorun" # Minitest
require "./lib/authing_ruby.rb" # 模块主文件
require "./lib/test/helper.rb" # 模块主文件
require 'dotenv' # 载入环境变量文件
Dotenv.load('.env.test') # 你可以编辑这个文件来修改环境变量

class TestManagementClient < Minitest::Test

	# 测试创建用户
	def test_users_create
		options = {
			host: 'https://core.authing.cn',
      userPoolId: ENV["userPoolId"],
      secret: ENV["secret"],
    }
		managementClient = AuthingRuby::ManagementClient.new(options)
    res = managementClient.users.create({
			username: 'SpongeBob',
			password: 'passw0rd',
		})
		puts res
	end

end