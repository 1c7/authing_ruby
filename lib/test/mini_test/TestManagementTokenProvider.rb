# ruby ./lib/test/mini_test/TestManagementTokenProvider.rb

require "minitest/autorun" # Minitest
require "./lib/authing_ruby.rb" # 模块主文件
require "./lib/test/helper.rb" # 模块主文件
require 'dotenv' # 载入环境变量文件
Dotenv.load('.env.test') # 你可以编辑这个文件来修改环境变量

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