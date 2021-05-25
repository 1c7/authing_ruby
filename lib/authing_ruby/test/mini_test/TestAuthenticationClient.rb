# 测试内容: 用户认证模块-认证核心模块
# 如何运行: ruby ./lib/authing_ruby/test/mini_test/TestAuthenticationClient.rb

require "minitest/autorun" # Minitest
require "./lib/authing_ruby.rb" # 模块主文件
require "./lib/authing_ruby/test/helper.rb"
require 'dotenv'
Dotenv.load('.env.test') # 你可以编辑这个文件来修改环境变量
# 备注: 不要用 staging 或 production 环境的用户池来测试，新建一个用户池专门做测试，因为测试期间会注册随机名字的用户

class TestAuthenticationClient < Minitest::Test
  def setup
    options = {
      # appHost: ENV["appHost"], # "https://rails-demo.authing.cn", 
      # appId: ENV["appId"], # "60800b9151d040af9016d60b"
      appId: "60ab26fe5be730bfc1742c68",
      appHost: "https://hn-staging.authing.cn",
    }
    @authenticationClient = AuthingRuby::AuthenticationClient.new(options)
    @helper = Test::Helper.new
  end

  # 测试: 手机号+验证码+密码 注册
  # 需要手动测试（填验证码）
  # ruby ./lib/authing_ruby/test/mini_test/TestAuthenticationClient.rb -n test_registerByPhoneCode
  def test_registerByPhoneCode
    phone = '13556136684'
    code = '8086' 
    password = '1234567890'
    res = @authenticationClient.registerByPhoneCode(phone, code, password)
    # puts '拿到的结果是:-----'
    # puts res
    # {:code=>2026, :message=>"用户已存在，请直接登录！", :data=>nil}
    # {:code=>2001, :message=>"验证码不正确！", :data=>nil}

    # 如果成功
    # {"id"=>"60ad0c49d6e166f9fe23ba4d", "arn"=>"arn:cn:authing:60ab26fe478f98290befefaa:user:60ad0c49d6e166f9fe23ba4d", "userPoolId"=>"60ab26fe478f98290befefaa", "status"=>"Activated", "username"=>nil, "email"=>nil, "emailVerified"=>false, "phone"=>"13556136684", "phoneVerified"=>true, "unionid"=>nil, "openid"=>nil, "nickname"=>nil, "registerSource"=>["basic:phone-code"], "photo"=>"default-user-avatar.png", "password"=>"0361a6088087f31edd172c4f6076c0e6", "oauth"=>nil, "token"=>nil, "tokenExpiredAt"=>nil, "loginsCount"=>0, "lastLogin"=>nil, "lastIP"=>nil, "signedUp"=>nil, "blocked"=>false, "isDeleted"=>false, "device"=>nil, "browser"=>nil, "company"=>nil, "name"=>nil, "givenName"=>nil, "familyName"=>nil, "middleName"=>nil, "profile"=>nil, "preferredUsername"=>nil, "website"=>nil, "gender"=>"U", "birthdate"=>nil, "zoneinfo"=>nil, "locale"=>nil, "address"=>nil, "formatted"=>nil, "streetAddress"=>nil, "locality"=>nil, "region"=>nil, "postalCode"=>nil, "city"=>nil, "province"=>nil, "country"=>nil, "createdAt"=>"2021-05-25T14:40:09+00:00", "updatedAt"=>"2021-05-25T14:40:09+00:00", "externalId"=>nil}
  end

  # 测试邮箱+密码注册
  # ruby /lib/authing_ruby/test/mini_test/TestAuthenticationClient.rb -n test_registerByEmail
  def test_registerByEmail
    random_string = @helper.randomNumString()
    email = "#{random_string}@qq.com"
    password = "12345678"
    resp = @authenticationClient.registerByEmail(email, password)
    # 如果失败
    # {"errors"=>[{"message"=>{"code"=>2026, "message"=>"用户已存在，请直接登录！"}, "locations"=>[{"line"=>2, "column"=>3}], "path"=>["registerByEmail"], "extensions"=>{"code"=>"INTERNAL_SERVER_ERROR"}}], "data"=>{"registerByEmail"=>nil}}
    
    # 如果成功
    # {"id"=>"6083842709f7934053e988f6", "arn"=>"arn:cn:authing:60800b8ee5b66b23128b4980:user:6083842709f7934053e988f6", "userPoolId"=>"60800b8ee5b66b23128b4980", "status"=>"Activated", "username"=>nil, "email"=>"401@qq.com", "emailVerified"=>false, "phone"=>nil, "phoneVerified"=>false, "unionid"=>nil, "openid"=>nil, "nickname"=>nil, "registerSource"=>["basic:email"], "photo"=>"default-user-avatar.png", "password"=>"ec0bad9e7bbdf8d71c8e717849954520", "oauth"=>nil, "token"=>nil, "tokenExpiredAt"=>nil, "loginsCount"=>0, "lastLogin"=>nil, "lastIP"=>nil, "signedUp"=>nil, "blocked"=>false, "isDeleted"=>false, "device"=>nil, "browser"=>nil, "company"=>nil, "name"=>nil, "givenName"=>nil, "familyName"=>nil, "middleName"=>nil, "profile"=>nil, "preferredUsername"=>nil, "website"=>nil, "gender"=>"U", "birthdate"=>nil, "zoneinfo"=>nil, "locale"=>nil, "address"=>nil, "formatted"=>nil, "streetAddress"=>nil, "locality"=>nil, "region"=>nil, "postalCode"=>nil, "city"=>nil, "province"=>nil, "country"=>nil, "createdAt"=>"2021-04-24T02:36:23+00:00", "updatedAt"=>"2021-04-24T02:36:23+00:00", "externalId"=>nil}
    assert(resp.dig('id'), resp)
  end

  # 测试用户名+密码注册
  # ruby /lib/authing_ruby/test/mini_test/TestAuthenticationClient.rb -n test_registerByUsername
  def test_registerByUsername
    random_string = @helper.randomString(9)
    username = random_string
    password = random_string
    resp = @authenticationClient.registerByUsername(username, password)
    assert(resp.dig('id'), resp)
  end

  # 测试邮箱+密码登录
  # ruby /lib/authing_ruby/test/mini_test/TestAuthenticationClient.rb -n test_loginByEmail
  def test_loginByEmail
    # 第一步：先注册
    random_string = @helper.randomString(9)
    email = "#{random_string}@qq.com"
    password = random_string
    @authenticationClient.registerByEmail(email, password)

    # 第二步：登录
    resp = @authenticationClient.loginByEmail(email, password)
    assert(resp.dig('id'), resp)
  end

  # 测试用户名+密码登录
  # ruby /lib/authing_ruby/test/mini_test/TestAuthenticationClient.rb -n test_loginByUsername
  def test_loginByUsername
    random_string = @helper.randomString(9)
    username = random_string
    password = random_string
    @authenticationClient.registerByUsername(username, password)
    resp = @authenticationClient.loginByUsername(username, password)
    assert(resp.dig('id'), resp)
  end

  # 测试手机号+密码登录
  # def test_loginByPhonePassword
  # end

  # 测试获取当前用户
  # ruby ./lib/authing_ruby/test/mini_test/TestAuthenticationClient.rb -n test_getCurrentUser
  def test_getCurrentUser
    # 注册+登录
    username = "test_getCurrentUser_#{@helper.randomString()}"
    password = "123456789"
    @authenticationClient.registerByUsername(username, password)
    @authenticationClient.loginByUsername(username, password)

    # 获取用户信息
    user = @authenticationClient.getCurrentUser()
    assert(user.dig("id"), user)
  end

  # 测试退出登录
  # ruby /lib/authing_ruby/test/mini_test/TestAuthenticationClient.rb -n test_logout
  def test_logout
    # 如何测试?
    # 1. 先登录, 用身份去做一些事情 （比如修改 nickname）
    # 2. 再登出, 做同样的事情，但是这次会失败

    # 注册+登录
    username = 'zhengcheng123'
    password = "123456789"
    @authenticationClient.registerByUsername(username, password)
    @authenticationClient.loginByUsername(username, password)

    # 更新用户信息  
    res1 = @authenticationClient.updateProfile({
      nickname: '昵称修改-这次会成功'
    })

    # 退出登录
    @authenticationClient.logout()

    # 更新用户信息
    begin
      res2 = @authenticationClient.updateProfile({
        nickname: '昵称-这次会失败'
      })
      puts res2
    rescue => e
      assert(e.message == '请先登录!')
    end
  end

  # 测试: 修改用户资料
  # 需要手动测试（确保用户名+密码账号的确存在）
  # ruby ./lib/authing_ruby/test/mini_test/TestAuthenticationClient.rb -n test_updateProfile
  def test_updateProfile
    # 先登录
    username = 'zhengcheng123'
    password = "123456789"
    @authenticationClient.registerByUsername(username, password)
    @authenticationClient.loginByUsername(username, password)

    # 进行第一次修改
    @authenticationClient.updateProfile({
      nickname: '第一次修改'
    })

    # 进行第二次修改
    nickname = '第二次修改'
    user = @authenticationClient.updateProfile({
      nickname: nickname
    })
    user_nickname = user.dig('nickname')
    assert(user_nickname == nickname)
  end

  # 测试: 检查密码强度
  # ruby /lib/authing_ruby/test/mini_test/TestAuthenticationClient.rb -n test_checkPasswordStrength
  # 注意, 在 Authing 用户池里 -> "扩展能力" -> "自定义密码加密"，选的是 "用户可使用任意非空字符串作为密码"
  def test_checkPasswordStrength
    password = "123"
    r = @authenticationClient.checkPasswordStrength(password)
    assert(r['valid'], r)

    # 默认情况下：用户可使用任意非空字符串作为密码，返回是
    # {"valid"=>true, "message"=>"密码验证成功"}
    
    # 如果修改为：用户须使用至少 6 位字符作为密码，返回是：
    # {"valid"=>false, "message"=>"密码长度不能少于 6 位"}

    # 如果传递一个空字符串
    password = ""
    r = @authenticationClient.checkPasswordStrength(password)
    # {"valid"=>false, "message"=>"请输入密码"}
    assert(r['valid'] == false, r)
  end

  # 测试: 更新用户密码
  # ruby /lib/authing_ruby/test/mini_test/TestAuthenticationClient.rb -n test_updatePassword
  def test_updatePassword
    # 例子1：如果不登陆，直接改，会提示尚未登录
    # oldPassword = "123456789"
    # newPassword = "123456789-ABC"
    # res = @authenticationClient.updatePassword(newPassword, oldPassword)
    # puts res
    # {"errors"=>[{"message"=>{"code"=>2020, "message"=>"尚未登录，无访问权限"}, "locations"=>[{"line"=>2, "column"=>3}], "path"=>["updatePassword"], "extensions"=>{"code"=>"INTERNAL_SERVER_ERROR"}}], "data"=>nil}

    # 第一步：注册用户
    username = "username_test_updatePassword_#{@helper.randomString()}"
    password = "123456789"
    @authenticationClient.registerByUsername(username, password)

    # 第二步：登录用户
    @authenticationClient.loginByUsername(username, password)

    # 第三步：更新密码
    oldPassword = password
    newPassword = "987654321"
    result = @authenticationClient.updatePassword(newPassword, oldPassword)

    # 第四步：看返回结果对不对
    assert(result.dig('id') != nil, result)
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

  # 测试: 检测 Token 登录状态
  # ruby ./lib/authing_ruby/test/mini_test/TestAuthenticationClient.rb -n test_checkLoginStatus
  def test_checkLoginStatus
    # 第一步：先登录然后获取 token
    username = 'zhengcheng123'
    password = "123456789"
    @authenticationClient.registerByUsername(username, password)
    user = @authenticationClient.loginByUsername(username, password)
    token = user.dig("token")

    # 第二步：检测 Token 登录状态
    result1 = @authenticationClient.checkLoginStatus(token)
    # puts result1
    # {"code"=>200, "message"=>"已登录", "status"=>true, "exp"=>1620911894, "iat"=>1619702294, "data"=>{"id"=>"608966b08b4af522620d2e59", "userPoolId"=>"60800b8ee5b66b23128b4980", "arn"=>nil}
    assert(result1['code'] == 200, result1)

    # 第三步：登出
    @authenticationClient.logout()

    # 第四步：再次检测
    result2 = @authenticationClient.checkLoginStatus(token)
    # puts result2
    # {"code"=>2206, "message"=>"登录信息已过期", "status"=>false, "exp"=>nil, "iat"=>nil, "data"=>nil}
    assert(result2['code'] == 2206, result2)
  end
  
end