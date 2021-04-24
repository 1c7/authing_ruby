# 复刻一个  JS SDK 的 HttpClient
# 问题: 这个 HttpClient 和 GraphqlClient 有什么区别?
# graphqlClient 是写死的 POST 请求
# httpClient 的是自己定的
# https://github.com/Authing/authing.js/blob/196b33fe0c7f510ca26cda4d172939e1c74cc5f7/src/lib/common/HttpClient.ts
require './lib/version.rb';
require "http"

module Common
	class HttpClient
		def initialize(options = {}, tokenProvider)
			@options = options
			@tokenProvider = tokenProvider
		end
		def request(config)
			headers = {
				'x-authing-sdk-version': "ruby:#{Authing::VERSION}",
				'x-authing-userpool-id': @options.fetch(:userPoolId, ''),
				'x-authing-request-from': @options.fetch(:requestFrom, 'sdk'),
				'x-authing-app-id': @options.fetch(:appId, ''),
				'x-authing-lang': @options.fetch(:lang, ''),
			};
			token = options.fetch(:token, nil)
			if token
				headers['Authorization'] = "Bearer #{token}"
			end
			# response = HTTP.headers(headers).post(@endpoint, json: json)
    	# return response.body.to_s
		end
	end
end