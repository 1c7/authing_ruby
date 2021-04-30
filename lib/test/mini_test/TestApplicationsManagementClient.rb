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
    @managementClient = AuthingRuby::ManagementClient.new(@options)
  end

  # 创建应用
  # ruby ./lib/test/mini_test/TestApplicationsManagementClient.rb -n test_create
  def test_create
    res = @managementClient.applications.create({
			name: '应用名称1000',
			identifier: 'app1000',
		})
    json = JSON.parse(res.body)
    assert(json["code"] == 200, res.body)
    # 错误情况1
    # {"code":2039,"message":"域名已被占用"}

    # 清理工作：删掉这个应用
    appid = json.dig("data", "id")
    @managementClient.applications.delete(appid)
  end

  # 删除应用
  # ruby ./lib/test/mini_test/TestApplicationsManagementClient.rb -n test_delete
  def test_delete
    # 先创建一个应用
    res = @managementClient.applications.create({
			name: '应用名称10',
			identifier: 'app10',
		})
    json = JSON.parse(res.body)
    appid = json.dig("data", "id")

    # 然后删除这个应用
    res = @managementClient.applications.delete(appid)
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
    # 先创建应用
    res = @managementClient.applications.create({
			name: '应用名称20',
			identifier: 'app20',
		})
    json = JSON.parse(res.body)
    appid = json.dig("data", "id")

    # 然后查询这个应用
    res = @managementClient.applications.findById(appid)
    json = JSON.parse(res.body)
    assert(json["code"] == 200, res.body)

    # 清理工作：最后删除掉这个应用
    @managementClient.applications.delete(appid)
  end

end