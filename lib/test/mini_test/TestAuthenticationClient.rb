# http://docs.seattlerb.org/minitest/
# 如何运行 ruby ./lib/test/mini_test/TestAuthenticationClient.rb

require "minitest/autorun" # Minitest
require "./lib/authing_ruby.rb" # 模块主文件
require "./lib/test/helper.rb" # 模块主文件
require 'dotenv' # 载入环境变量文件

Dotenv.load('.env.test') # 你可以编辑这个文件来修改环境变量
# 不要用 staging 或 production 的用户池来测试，新建一个用户池专门做测试，因为测试期间会注册随机名字的用户

class TestAuthenticationClient < Minitest::Test
  def setup
    options = {
      appHost: ENV["appHost"], # "https://rails-demo.authing.cn", 
      appId: ENV["appId"], # "60800b9151d040af9016d60b"
    }
    @authenticationClient = AuthingRuby::AuthenticationClient.new(options)
    @test_helper = Test::Helper.new
  end

  # 测试邮箱+密码注册
  def test_registerByEmail
    random_string = @test_helper.randomNumString()
    email = "#{random_string}@qq.com"
    password = "12345678"
    resp = @authenticationClient.registerByEmail(email, password)
    json = JSON.parse(resp)
    # example_error_2026 = {"errors"=>[{"message"=>{"code"=>2026, "message"=>"用户已存在，请直接登录！"}, "locations"=>[{"line"=>2, "column"=>3}], "path"=>["registerByEmail"], "extensions"=>{"code"=>"INTERNAL_SERVER_ERROR"}}], "data"=>{"registerByEmail"=>nil}}
    # example_success = {"data"=>{"registerByEmail"=>{"id"=>"6083842709f7934053e988f6", "arn"=>"arn:cn:authing:60800b8ee5b66b23128b4980:user:6083842709f7934053e988f6", "userPoolId"=>"60800b8ee5b66b23128b4980", "status"=>"Activated", "username"=>nil, "email"=>"401@qq.com", "emailVerified"=>false, "phone"=>nil, "phoneVerified"=>false, "unionid"=>nil, "openid"=>nil, "nickname"=>nil, "registerSource"=>["basic:email"], "photo"=>"default-user-avatar.png", "password"=>"ec0bad9e7bbdf8d71c8e717849954520", "oauth"=>nil, "token"=>nil, "tokenExpiredAt"=>nil, "loginsCount"=>0, "lastLogin"=>nil, "lastIP"=>nil, "signedUp"=>nil, "blocked"=>false, "isDeleted"=>false, "device"=>nil, "browser"=>nil, "company"=>nil, "name"=>nil, "givenName"=>nil, "familyName"=>nil, "middleName"=>nil, "profile"=>nil, "preferredUsername"=>nil, "website"=>nil, "gender"=>"U", "birthdate"=>nil, "zoneinfo"=>nil, "locale"=>nil, "address"=>nil, "formatted"=>nil, "streetAddress"=>nil, "locality"=>nil, "region"=>nil, "postalCode"=>nil, "city"=>nil, "province"=>nil, "country"=>nil, "createdAt"=>"2021-04-24T02:36:23+00:00", "updatedAt"=>"2021-04-24T02:36:23+00:00", "externalId"=>nil}}}
    assert(json.dig('data', 'registerByEmail'), "邮箱+密码注册失败")
    # 如果这个 json.data.registerByEmail 属性存在我们就认为是成功
  end

  # 测试用户名+密码注册
  def test_registerByUsername
    random_string = @test_helper.randomNumString()
    username = random_string
    password = random_string
    resp = @authenticationClient.registerByUsername(username, password)
    json = JSON.parse(resp)
    assert(json.dig('data', 'registerByUsername'), "用户名+密码注册失败")
  end

  # 测试邮箱+密码登录
  # ruby ./lib/test/mini_test/TestAuthenticationClient.rb -n test_loginByEmail
  def test_loginByEmail
    random_string = @test_helper.randomNumString()
    email = "#{random_string}@qq.com"
    password = random_string
    # 先注册
    @authenticationClient.registerByEmail(email, password)
    # 再登录
    resp = @authenticationClient.loginByEmail(email, password)
    json = JSON.parse(resp)
    assert(json.dig('data', 'loginByEmail'), "邮箱+密码登录失败")
  end

  # 测试用户名+密码登录
  # ruby ./lib/test/mini_test/TestAuthenticationClient.rb -n test_loginByUsername
  def test_loginByUsername
    random_string = @test_helper.randomNumString()
    username = random_string
    password = random_string
    @authenticationClient.registerByUsername(username, password)
    resp = @authenticationClient.loginByUsername(username, password)
    json = JSON.parse(resp)
    dig = json.dig('data', 'loginByUsername')
    assert(dig, "用户名+密码注册失败")
  end

  # 测试手机号+密码登录
  # def test_loginByPhonePassword
  # end

  # 测试获取当前用户
  # def test_getCurrentUser
  # end

  # TODO
  # 测试退出登录
  # ruby ./lib/test/mini_test/TestAuthenticationClient.rb -n test_logout
  def test_logout
    # 如何测试?
    # 1. 先登录, 用身份去做一些事情 （比如修改 username 改个名字）
    # 2. 再登出, 做同样的事情，但是这次会失败

    # 注册+登录
    username = 'zhengcheng123'
    password = "123456789"
    @authenticationClient.registerByUsername(username, password)
    @authenticationClient.loginByUsername(username, password)
    # userID = @authenticationClient.checkLoggedIn()
    # puts userID

    # 更新用户信息  
    res = @authenticationClient.updateProfile({
      nickname: 'Nick-2021-4-29 第一次'
    })
    puts res
  end

  # 测试: 修改用户资料
  # ruby ./lib/test/mini_test/TestAuthenticationClient.rb -n test_updateProfile
  def test_updateProfile
    username = 'zhengcheng123'
    password = "123456789"
    @authenticationClient.loginByUsername(username, password)
    res = @authenticationClient.updateProfile({
      nickname: '第一次修改'
    })
    res = @authenticationClient.updateProfile({
      nickname: '第二次修改'
    })
    puts res
  end

  # 测试: 更新用户密码
  def test_updatePassword
  end

  # 测试: 绑定手机号
  def test_bindPhone
  end 

  # 测试: 解绑手机号
  def test_unbindPhone
  end

  # 测试: 更新用户手机号
  def test_updatePhone
  end

  # 绑定邮箱
  def test_bindEmail
  end

  # 解绑邮箱
  def test_unbindEmail
  end

  # 检测 Token 登录状态
  def test_checkLoginStatus
  end
  
end