# ruby ./lib/test/mini_test/TestApplicationsManagementClient.rb

require "minitest/autorun"
require "./lib/authing_ruby.rb"
require "./lib/test/helper.rb"
require 'dotenv'
Dotenv.load('.env.test') 

# 测试"管理应用"
# https://docs.authing.cn/v2/reference/sdk-for-node/management/ApplicationManagementClient.html
class TestApplicationsManagementClient < Minitest::Test

	def setup
    @options = {
      host: 'https://core.authing.cn',
      userPoolId: ENV["userPoolId"],
      secret: ENV["secret"],
    }
  end

  # 创建应用
  # ruby ./lib/test/mini_test/TestApplicationsManagementClient.rb -n test_create
  def test_create
    managementClient = AuthingRuby::ManagementClient.new(@options)
    res = managementClient.applications.create({
			name: '应用名称4',
			identifier: 'app4',
		})
    json = JSON.parse(res.body)
    assert(json["code"] == 200, res.body)
  end

  # 删除应用
  # ruby ./lib/test/mini_test/TestApplicationsManagementClient.rb -n test_delete
  def test_delete
    appid = "60893b8db4486990c1b0a79c"
    managementClient = AuthingRuby::ManagementClient.new(@options)
    res = managementClient.applications.delete(appid)
    json = JSON.parse(res.body)
    assert(json["code"] == 200, res.body)
  end

  # 获取应用列表
  # ruby ./lib/test/mini_test/TestApplicationsManagementClient.rb -n test_list
  def test_list
    managementClient = AuthingRuby::ManagementClient.new(@options)
    res = managementClient.applications.list()
    json = JSON.parse(res.body)
    assert(json["code"] == 200, res.body)
  end

  # 获取应用详情
  # ruby ./lib/test/mini_test/TestApplicationsManagementClient.rb -n test_findById
  def test_findById
    appid = "60800b9151d040af9016d60b"
    managementClient = AuthingRuby::ManagementClient.new(@options)
    res = managementClient.applications.findById(appid)
    json = JSON.parse(res.body)
    assert(json["code"] == 200, res.body)
  end

end