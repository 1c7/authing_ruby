# http://docs.seattlerb.org/minitest/
# 如何运行 ruby ./lib/test/TestAuthenticationClient.rb

require "minitest/autorun" # Minitest
require "./lib/authing_ruby.rb" # 模块主文件
require "./lib/test/helper.rb" # 模块主文件
require 'dotenv' # 载入环境变量文件
Dotenv.load('.env.test')

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

  def test_registerByUsername
  end

  def test_loginByEmail
  end

  def test_loginByUsername
  end

  def test_loginByPhonePassword
  end

  def test_getCurrentUser
  end
  
end