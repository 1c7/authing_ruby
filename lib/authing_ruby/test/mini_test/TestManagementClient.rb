# ruby ./lib/test/mini_test/TestManagementClient.rb

require "minitest/autorun"
require "./lib/authing_ruby.rb"
require "./lib/authing_ruby/test/helper.rb"
require 'dotenv'
Dotenv.load('.env.test') 

class TestManagementClient < Minitest::Test
  def setup
    @options = {
      host: 'https://core.authing.cn',
      # host: 'https://core.authing.co', # 2021-5-13 他们临时使用 .co，过几天等他们恢复了 .cn 这里就改回 .cn
      userPoolId: ENV["userPoolId"],
      secret: ENV["secret"],
    }
    @helper = Test::Helper.new
  end

  # 创建用户
  # ruby ./lib/authing_ruby/test/mini_test/TestManagementClient.rb -n test_users_create
  def test_users_create
    managementClient = AuthingRuby::ManagementClient.new(@options)
    random_phone = "135#{@helper.randomNumString(8)}"
    userInfo = {
      # username: @helper.randomString, # 随机字符串，比如 "mpflok"
      # username: 'SpongeBob3', # 或者明确指定用户名
      phone: random_phone,
      password: '123456789',
    }
    puts userInfo
    hash = managementClient.users.create(userInfo)
    
    # 成功
    # {"data":{"createUser":{"id":"608ab9828eab7e35e81bd732","arn":"arn:cn:authing:60800b8ee5b66b23128b4980:user:608ab9828eab7e35e81bd732","userPoolId":"60800b8ee5b66b23128b4980","status":"Activated","username":"SpongeBob2","email":null,"emailVerified":false,"phone":null,"phoneVerified":false,"unionid":null,"openid":null,"nickname":null,"registerSource":["import:manual"],"photo":"default-user-avatar.png","password":"91b133c2e13e40852505946b7e0c2f04","oauth":null,"token":null,"tokenExpiredAt":null,"loginsCount":0,"lastLogin":null,"lastIP":null,"signedUp":null,"blocked":false,"isDeleted":false,"device":null,"browser":null,"company":null,"name":null,"givenName":null,"familyName":null,"middleName":null,"profile":null,"preferredUsername":null,"website":null,"gender":"U","birthdate":null,"zoneinfo":null,"locale":null,"address":null,"formatted":null,"streetAddress":null,"locality":null,"region":null,"postalCode":null,"city":null,"province":null,"country":null,"createdAt":"2021-04-29T13:49:54+00:00","updatedAt":"2021-04-29T13:49:54+00:00","externalId":null}}}
    
    # 失败
    # {"errors":[{"message":{"code":2026,"message":"用户已存在，请勿重复创建！"},"locations":[{"line":2,"column":3}],"path":["createUser"],"extensions":{"code":"INTERNAL_SERVER_ERROR"}}],"data":null}

    assert(hash.dig("data", "createUser") != nil, hash)
  end

  # 创建用户
  # ruby ./lib/test/mini_test/TestManagementClient.rb -n test_user_create_2
  def test_user_create_2
    managementClient = AuthingRuby::ManagementClient.new(@options)
    random_phone = "1350000#{rand(1000..9999)}"
    userInfo = {
      nickname: 'Nick Water3',
      phone: random_phone, # 由于是管理员操作，所以不需要检验手机号验证码, 如果你需要检验，请使用  AuthenticationClient
      loginsCount: 2, # 原有用户系统记录的用户登录次数
      signedUp: '2020-10-15T17:55:37+08:00' # 原有用户系统记录的用户注册时间
    }
    hash = managementClient.users.create(userInfo)
    assert(hash.dig("data", "createUser") != nil, hash)
  end

  # 创建一个用户, 并返回这个用户
  def create_random_user(userInfo = {})
    # 如果没传参数就用一个默认的，随机生成的。
    if userInfo.empty?
      random_phone = "1760000#{rand(1000..9999)}"
      userInfo = {
        nickname: "Nick #{random_phone}",
        phone: random_phone, # 由于是管理员操作，所以不需要检验手机号验证码, 如果你需要检验，请使用  AuthenticationClient
      }
    end

    managementClient = AuthingRuby::ManagementClient.new(@options)
    hash = managementClient.users.create(userInfo)
    user = hash.dig("data", "createUser")
    return user
  end

  # 更新用户
  # ruby ./lib/authing_ruby/test/mini_test/TestManagementClient.rb -n test_update_user
  def test_update_user
    # 第一步：创建用户
    user = create_random_user()
    user_id = user.dig("id") # "6088decdcc904f5c993d6226"

    # 第二步：更新用户
    managementClient = AuthingRuby::ManagementClient.new(@options)
    hash = managementClient.users.update(user_id, {
      nickname: 'Nick',
    })
    # puts res2
    # 如果失败
    # {"errors":[{"message":{"code":2004,"message":"用户不存在"},"locations":[{"line":2,"column":3}],"path":["updateUser"],"extensions":{"code":"INTERNAL_SERVER_ERROR"}}],"data":null}

    assert(hash.dig("data", "updateUser") != nil, hash)
  end

  # 测试通过 ID 获取用户信息
  # ruby ./lib/authing_ruby/test/mini_test/TestManagementClient.rb -n test_detail
  def test_detail
    user = create_random_user()
    user_id = user.dig("id")

    managementClient = AuthingRuby::ManagementClient.new(@options)
    hash = managementClient.users.detail(user_id)
    assert(hash.dig("data", "user") != nil, hash)
  end
  
  # 测试删除用户
  # ruby ./lib/authing_ruby/test/mini_test/TestManagementClient.rb -n test_delete
  def test_delete
    user = create_random_user()
    user_id = user.dig("id")

    managementClient = AuthingRuby::ManagementClient.new(@options)
    hash = managementClient.users.delete(user_id)
    # {"data":{"deleteUser":{"message":"删除成功！","code":200}}}
    assert(hash.dig("data", "deleteUser") != nil, hash)
  end

  # 测试删除多个用户
  # ruby ./lib/test/mini_test/TestManagementClient.rb -n test_deleteMany
  def test_deleteMany
    user1 = create_random_user()
    user1_id = user1.dig("id")

    user2 = create_random_user()
    user2_id = user2.dig("id")

    user_ids = [user1_id, user2_id]

    managementClient = AuthingRuby::ManagementClient.new(@options)
    hash = managementClient.users.deleteMany(user_ids)
    # {"data":{"deleteUsers":{"message":"删除成功！","code":200}}}
    assert(hash.dig("data", "deleteUsers") != nil, hash)
  end

  # 测试获取用户列表
  # ruby ./lib/test/mini_test/TestManagementClient.rb -n test_list
  def test_list
    managementClient = AuthingRuby::ManagementClient.new(@options)
    hash = managementClient.users.list()
    assert(hash.dig("data", "users") != nil, hash)
  end

  # 测试 检查用户是否存在 (返回 true | false)
  # ruby ./lib/test/mini_test/TestManagementClient.rb -n test_exists
  def test_exists
    # 第一步：先创建用户
    userInfo = {
      "username": "bob",
    }
    create_random_user(userInfo)

    # 第二步：检查是否存在
    managementClient = AuthingRuby::ManagementClient.new(@options)
    options = { 
      "username": "bob",
      # "email": "haha2@qq.com",
      # "phone": "13700001111",
    }
    boolean = managementClient.users.exists(options)
    assert(boolean)
  end

  # 测试 查找用户 (返回这个用户)
  # ruby ./lib/authing_ruby/test/mini_test/TestManagementClient.rb -n test_find
  def test_find
    # 第一步：先创建用户
    userInfo = {
      "username": "alice",
    }
    create_random_user(userInfo)

    managementClient = AuthingRuby::ManagementClient.new(@options)
    options = { 
      "username": "alice",
      # "email": "haha2@qq.com",
      # "phone": "13700001111",
    }
    result = managementClient.users.find(options)
    assert(result.dig("data", "findUser"), result)
  end

end