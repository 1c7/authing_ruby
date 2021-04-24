# http://docs.seattlerb.org/minitest/
# 如何运行 ruby ./lib/test/TestAuthenticationClient.rb

require "minitest/autorun" # Minitest
require "./lib/authing_ruby.rb" # 模块主文件
require 'dotenv' # 载入环境变量文件
Dotenv.load('.env.test')

class TestAuthenticationClient < Minitest::Test
  def setup
    options = {
      appHost: ENV["appHost"], # "https://rails-demo.authing.cn", 
      appId: ENV["appId"], # "60800b9151d040af9016d60b"
    }
    @authenticationClient = AuthingRuby::AuthenticationClient.new(options)
  end

  def test_registerByEmail
    email = '301@qq.com'
    password = "12345678"
    resp = @authenticationClient.registerByEmail(email, password)
    json = JSON.parse(resp)
    puts json
    
    # const authing = new AuthenticationClient(getOptionsFromEnv());
    # const email = generateRandomString() + '@test.com';
    # const password = generateRandomString();
    # const user = await authing.registerByEmail(email, password);
    # t.assert(user);

    # 
    # assert_equal 1, 2
  end
end