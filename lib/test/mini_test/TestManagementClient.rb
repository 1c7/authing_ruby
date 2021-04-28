# ruby ./lib/test/mini_test/TestManagementClient.rb

require "minitest/autorun" # Minitest
require "./lib/authing_ruby.rb" # 模块主文件
require "./lib/test/helper.rb" # 模块主文件
require 'dotenv' # 载入环境变量文件
Dotenv.load('.env.test') # 你可以编辑这个文件来修改环境变量

class TestManagementClient < Minitest::Test
  def setup
    @options = {
      host: 'https://core.authing.cn',
      userPoolId: ENV["userPoolId"],
      secret: ENV["secret"],
    }
  end

  # 创建用户
  def test_users_create
    managementClient = AuthingRuby::ManagementClient.new(@options)
    res = managementClient.users.create({
      username: 'SpongeBob',
      password: 'passw0rd',
    })
    puts res
  end

  # 创建用户
  # ruby ./lib/test/mini_test/TestManagementClient.rb -n test_user_create_2
  def test_user_create_2
    managementClient = AuthingRuby::ManagementClient.new(@options)
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
    managementClient = AuthingRuby::ManagementClient.new(@options)
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
    managementClient = AuthingRuby::ManagementClient.new(@options)
    user_id = "6088decdcc904f5c993d6226"
    # user_id = '[请填写用户 id]'
    res = managementClient.users.update(user_id, {
      nickname: 'Nick Fire',
      phone: '135xxxx6699', # 由于是管理员操作，所以不需要检验手机号验证码, 如果你需要检验，请使用  AuthenticationClient
    })
    puts res
  end

  # 测试通过 ID 获取用户信息
  # ruby ./lib/test/mini_test/TestManagementClient.rb -n test_detail
  def test_detail
    managementClient = AuthingRuby::ManagementClient.new(@options)
    user_id = "6088decdcc904f5c993d6226"
    # user_id = '[请填写用户 id]'
    res = managementClient.users.detail(user_id)
    puts res
  end
  
  # 测试删除用户
  # ruby ./lib/test/mini_test/TestManagementClient.rb -n test_delete
  def test_delete
    managementClient = AuthingRuby::ManagementClient.new(@options)
    user_id = "6088decdcc904f5c993d6226"
    res = managementClient.users.delete(user_id)
    puts res
    # {"data":{"deleteUser":{"message":"删除成功！","code":200}}}
  end

  # 测试删除多个用户
  # ruby ./lib/test/mini_test/TestManagementClient.rb -n test_deleteMany
  def test_deleteMany
    managementClient = AuthingRuby::ManagementClient.new(@options)
    user_ids = ["6088dd92940121678457ca76", "6083fd304bed72c74b8e3c49"]
    res = managementClient.users.deleteMany(user_ids)
    puts res
    # {"data":{"deleteUsers":{"message":"删除成功！","code":200}}}
  end

  # 测试获取用户列表
  # ruby ./lib/test/mini_test/TestManagementClient.rb -n test_list
  def test_list
    managementClient = AuthingRuby::ManagementClient.new(@options)
    res = managementClient.users.list()
    puts res
  end

  # 测试 检查用户是否存在
  # ruby ./lib/test/mini_test/TestManagementClient.rb -n test_exists
  def test_exists
    managementClient = AuthingRuby::ManagementClient.new(@options)
    options = { 
      "username": "bob",
      # "email": "haha2@qq.com",
      # "phone": "13700001111",
    }
    boolean = managementClient.users.exists(options)
    if boolean
      puts "该用户存在"
    else
      puts "该用户不存在"
    end
    # 这里就不写 assert() 了，测试的时候自己填名字人工测一下就行
  end

end