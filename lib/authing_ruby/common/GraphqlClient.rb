# GraphqlClient 负责发 GraphQL 请求 (其实就是 HTTP POST)
# 必须要这个是因为发请求要带上 'x-authing-userpool-id' 和 'x-authing-app-id 等 Header
# 模仿的是: 
# https://github.com/Authing/authing.js/blob/cf4757d09de3b44c3c3f4509ae8c8715c9f302a2/src/lib/common/GraphqlClient.ts#L6

require "http"
require_relative '../version.rb'

module AuthingRuby
  module Common
    class GraphqlClient
      def initialize(endpoint, options = {})
        @endpoint = endpoint # API 端点
        @options = options
      end

      # 发请求
      # 成功或失败都返回 Hash
      def request(options)
        headers = {
          'content-type': 'application/json',
          'x-authing-sdk-version': "ruby:#{AuthingRuby::VERSION}",
          'x-authing-userpool-id': @options.fetch(:userPoolId, ''),
          'x-authing-request-from': @options.fetch(:requestFrom, 'sdk'),
          'x-authing-app-id': @options.fetch(:appId, ''),
          'x-authing-lang': @options.fetch(:lang, ''),
        };
        token = options.fetch(:token, nil)
        if token
          headers['Authorization'] = "Bearer #{token}"
        end

        option_json = options.fetch(:json, nil)
        response = HTTP.headers(headers).post(@endpoint, json: option_json)

        # 如果直接拿 body，它的类型是：
        # puts response.body
        # puts response.body.class.name # HTTP::Response::Body
        
        # 如果转成 String：
        # puts response.body.to_s
        # puts response.body.to_s.class.name # String

        hash = JSON.parse(response.body.to_s)

        # 这里的错误处理代码参照的 JS SDK （src/lib/common/GraphqlClient.ts）
        if hash['errors'] == nil
          # 如果没错误
          return hash
        else
          # 如果有错误, 最后返回这3个字段就行
          code = nil
          message = nil
          data = nil

          hash['errors'].each do |e|
            if e['message']
              message = e['message'] 
              code = message['code']
              message = message['message']
              data = message['data']
            end
          end

          # 返回 Hash
          obj = { 
            code: code,
            message: message,
            data: data
          }
          return obj
        end
      end

    end
  end
end