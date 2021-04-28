# ruby ./lib/test/mini_test/TestManagementClient.rb

require "minitest/autorun" # Minitest
require "./lib/authing_ruby.rb" # 模块主文件
require "./lib/test/helper.rb" # 模块主文件
require 'dotenv' # 载入环境变量文件
Dotenv.load('.env.test') # 你可以编辑这个文件来修改环境变量

class TestManagementClient < Minitest::Test

  # 创建用户
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

  # 创建用户
  # ruby ./lib/test/mini_test/TestManagementClient.rb -n test_user_create_2
  def test_user_create_2
    options = {
      host: 'https://core.authing.cn',
      userPoolId: ENV["userPoolId"],
      secret: ENV["secret"],
    }
    managementClient = AuthingRuby::ManagementClient.new(options)
    res = managementClient.users.create({
      nickname: 'Nick Water',
      phone: '176xxxx6754', # 由于是管理员操作，所以不需要检验手机号验证码, 如果你需要检验，请使用  AuthenticationClient
      loginsCount: 2, # 原有用户系统记录的用户登录次数
      signedUp: '2020-10-15T17:55:37+08:00' # 原有用户系统记录的用户注册时间
   })
    puts res
  end

  # 更新用户
  # ruby ./lib/test/mini_test/TestManagementClient.rb -n test_update_user
  def test_update_user
    options = {
      host: 'https://core.authing.cn',
      userPoolId: ENV["userPoolId"],
      secret: ENV["secret"],
    }
    managementClient = AuthingRuby::ManagementClient.new(options)
    user_id = "6088decdcc904f5c993d6226"
    # user_id = '[请填写用户 id]'
    res = managementClient.users.update(user_id, {
      nickname: 'Nick',
    })
    puts res
  end

  # 更新用户
  # ruby ./lib/test/mini_test/TestManagementClient.rb -n test_update_user_2
  def test_update_user_2
    options = {
      host: 'https://core.authing.cn',
      userPoolId: ENV["userPoolId"],
      secret: ENV["secret"],
    }
    managementClient = AuthingRuby::ManagementClient.new(options)
    user_id = "6088decdcc904f5c993d6226"
    # user_id = '[请填写用户 id]'
    res = managementClient.users.update(user_id, {
      nickname: 'Nick Fire',
      phone: '135xxxx6699', # 由于是管理员操作，所以不需要检验手机号验证码, 如果你需要检验，请使用  AuthenticationClient
    })
    puts res
  end

end