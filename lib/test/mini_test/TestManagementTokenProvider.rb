# 这个文件测什么？ManagementTokenProvider
# 只是管理 accessToken
# ruby ./lib/test/mini_test/TestManagementTokenProvider.rb

require "minitest/autorun"
require "./lib/authing_ruby.rb"
require "./lib/test/helper.rb"
require 'dotenv'
Dotenv.load('.env.test') 

class TestManagementTokenProvider < Minitest::Test

  def setup
    appHost = ENV["appHost"]
    graphqlEndpoint = "#{appHost}/graphql/v2"
    graphqlClient = AuthingRuby::Common::GraphqlClient.new(graphqlEndpoint)

    options = {
      userPoolId: ENV["userPoolId"],
      secret: ENV["secret"],
    }
    @managementTokenProvider = AuthingRuby::ManagementTokenProvider.new(options, graphqlClient)
  end

  # ruby ./lib/test/mini_test/TestManagementTokenProvider.rb -n test_getToken
  def test_getToken
    token = @managementTokenProvider.getToken()
    assert(token != nil)
  end

  # ruby ./lib/test/mini_test/TestManagementTokenProvider.rb -n test_getAccessTokenFromServer
  def test_getAccessTokenFromServer
    token = @managementTokenProvider._getAccessTokenFromServer()
    assert(token != nil)
  end

  # ruby ./lib/test/mini_test/TestManagementTokenProvider.rb -n test_getClientWhenSdkInit
  def test_getClientWhenSdkInit
    token = @managementTokenProvider.getClientWhenSdkInit()
    assert(token != nil)
  end

  # ruby ./lib/test/mini_test/TestManagementTokenProvider.rb -n test_refreshToken
  def test_refreshToken
    token = @managementTokenProvider.refreshToken()
    assert(token != nil)
  end

end