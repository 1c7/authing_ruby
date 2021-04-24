# GraphqlClient 负责发 HTTP 请求
# 必须要这个是因为发请求要带上 'x-authing-userpool-id' 和 'x-authing-app-id 等 Header
# 模仿的是: 
# https://github.com/Authing/authing.js/blob/cf4757d09de3b44c3c3f4509ae8c8715c9f302a2/src/lib/common/GraphqlClient.ts#L6

require './lib/version.rb';
require "http"

module Common
	class GraphqlClient
		def initialize(endpoint, options = {})
			@endpoint = endpoint # API 端点
			@options = options
		end

		def request(options)
			headers = {
				'content-type': 'application/json',
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
			# puts "最后的 headers 是"
			# puts headers

			json = options.fetch(:json, nil)
			# puts "最后的 json 是"
			# puts json
			response = HTTP.headers(headers).post(@endpoint, json: json)
    	return response.body.to_s
		end

	end
end