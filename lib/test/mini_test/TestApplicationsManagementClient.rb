# ruby ./lib/test/mini_test/TestApplicationsManagementClient.rb

require "minitest/autorun" # Minitest
require "./lib/authing_ruby.rb" # 模块主文件
require "./lib/test/helper.rb" # 模块主文件
require 'dotenv' # 载入环境变量文件
Dotenv.load('.env.test') # 你可以编辑这个文件来修改环境变量

class TestApplicationsManagementClient < Minitest::Test

	def setup
    @options = {
      host: 'https://core.authing.cn',
      userPoolId: ENV["userPoolId"],
      secret: ENV["secret"],
    }
  end

  # 创建应用
  def test_create
    managementClient = AuthingRuby::ManagementClient.new(@options)
    res = managementClient.applications.create({
			name: '应用名称哈哈',
			identifier: 'identifier',
			# redirectUris: ['your usi'],
			# logo: 'logo'
		})
    puts res
  end

end