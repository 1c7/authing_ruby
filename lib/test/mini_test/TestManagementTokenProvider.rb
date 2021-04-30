# ruby ./lib/test/mini_test/TestManagementTokenProvider.rb

require "minitest/autorun"
require "./lib/authing_ruby.rb"
require "./lib/test/helper.rb"
require 'dotenv'
Dotenv.load('.env.test') 

class TestManagementTokenProvider < Minitest::Test

  # ruby ./lib/test/mini_test/TestManagementTokenProvider.rb -n test_getToken
  def test_getToken
    appHost = ENV["appHost"]
    graphqlEndpoint = "#{appHost}/graphql/v2"
    graphqlClient = AuthingRuby::Common::GraphqlClient.new(graphqlEndpoint)

    options = {
      userPoolId: ENV["userPoolId"],
      secret: ENV["secret"],
    }
    managementTokenProvider = AuthingRuby::ManagementTokenProvider.new(options, graphqlClient)
    token = managementTokenProvider.getToken()
    puts "token 是 #{token}"

    token = managementTokenProvider.getToken()
    puts "token 是 #{token}"
    
    token = managementTokenProvider.getToken()
    puts "token 是 #{token}"
  end

  # ruby ./lib/test/mini_test/TestManagementTokenProvider.rb -n test_getAccessTokenFromServer
  def test_getAccessTokenFromServer
    appHost = ENV["appHost"]
    graphqlEndpoint = "#{appHost}/graphql/v2"
    graphqlClient = AuthingRuby::Common::GraphqlClient.new(graphqlEndpoint)

    options = {
      userPoolId: ENV["userPoolId"],
      secret: ENV["secret"],
    }
    managementTokenProvider = AuthingRuby::ManagementTokenProvider.new(options, graphqlClient)
    result = managementTokenProvider._getAccessTokenFromServer()
    puts "测试结果是 #{result}"
  end

  # Done
  def test_getClientWhenSdkInit
    appHost = ENV["appHost"]
    graphqlEndpoint = "#{appHost}/graphql/v2"
    graphqlClient = AuthingRuby::Common::GraphqlClient.new(graphqlEndpoint)

    options = {
      userPoolId: ENV["userPoolId"],
      secret: ENV["secret"],
    }
    managementTokenProvider = AuthingRuby::ManagementTokenProvider.new(options, graphqlClient)
    result = managementTokenProvider.getClientWhenSdkInit()
    # puts result
  end

  # TODO
  def test_refreshToken
    appHost = ENV["appHost"]
    graphqlEndpoint = "#{appHost}/graphql/v2"
    graphqlClient = AuthingRuby::Common::GraphqlClient.new(graphqlEndpoint)

    options = {
      userPoolId: ENV["userPoolId"],
      secret: ENV["secret"],
    }
    managementTokenProvider = AuthingRuby::ManagementTokenProvider.new(options, graphqlClient)
    # result = managementTokenProvider.refreshToken()
    # puts result
  end

end