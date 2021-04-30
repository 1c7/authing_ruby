# 复刻一个 JS SDK 的 HttpClient
# 问题: 这个 HttpClient 和 GraphqlClient 有什么区别?
# graphqlClient 是写死的 POST 请求
# httpClient 的是自己定的，可以是 GET, POST, DELETE 等
# https://github.com/Authing/authing.js/blob/196b33fe0c7f510ca26cda4d172939e1c74cc5f7/src/lib/common/HttpClient.ts
# https://github.com/Authing/authing.js/blob/master/src/lib/common/HttpClient.ts

# 如何使用？
=begin
发送一个 POST 请求
  httpClient = AuthingRuby::Common::HttpClient.new
  httpClient.request({
    method: 'POST',
    url: "https://postman-echo.com/post",
    data: {
      "x": 100,
      "y": 200,
    }
  })

发送一个 GET 请求
  httpClient = AuthingRuby::Common::HttpClient.new
  url = "https://postman-echo.com/get"
  resp = httpClient.request({
    method: 'GET',
    url: url,
    params: {
      "a": 3,
      "b": 4,
    }
  })

处理返回结果
  result = @httpClient.request({
    method: 'POST',
    url: "#{@options.fetch(:host, nil)}/api/v2/applications",
    data: {
      "name": options.fetch(:name, nil),
      "identifier": options.fetch(:identifier, nil),
      "redirectUris": options.fetch(:redirectUris, nil),
      "logo": options.fetch(:logo, nil),
    }
  });
  return result; # #<Faraday::Response:0x00007fcfce0ce450>
  return result.body # 这个才是返回, 不过是 String 类型
  JSON.parse(result.body)

=end

require "http"
require 'faraday'
require_relative '../version.rb'

module AuthingRuby
  module Common

    class HttpClient
      METHODS = %i[get post put delete]
      # METHODS = %i[get post put delete head patch options trace]
      
      def initialize(options = {}, tokenProvider = nil)
        @options = options
        @tokenProvider = tokenProvider
      end

      # 目的: 把 Faraday 稍微封装一下，因为 Faraday 不能动态指定方法（文档里没写），不像 js 的 axios。
      # https://github.com/lostisland/faraday/blob/main/lib/faraday/connection.rb
      # https://www.rubydoc.info/github/lostisland/faraday/Faraday/Connection
      # 返回 <Faraday::Response>
      def faraday_conn(config = {})
        method = config.fetch(:method, nil)
        if method == nil
          raise "必须传入 method，可选值 #{METHODS.join(', ')}"
        end
        method_downcase = method.downcase # 转成小写
        if METHODS.include?(method_downcase.to_sym) == false
          raise "传入的 method 错误，可选值 #{METHODS.join(', ')}"
        end

        url = config.fetch(:url, nil)
        data = config.fetch(:data, nil) # data 和 body 一回事
        params = config.fetch(:params, nil)
        headers = config.fetch(:headers, nil)

        if method_downcase == 'get'
          conn = Faraday::Connection.new url
          return conn.get nil, params, headers
        end

        if method_downcase == 'post'
          conn = Faraday::Connection.new url
          return conn.post nil, data, headers
        end

        if method_downcase == 'put'
          conn = Faraday::Connection.new url
          return conn.put nil, data, headers
        end

        if method_downcase == 'delete'
          conn = Faraday::Connection.new url
          return conn.delete nil, params, headers
        end
      end

      def request(config = {})
        # 处理 config 里5个参数：method, url, data, params, headers
        method = config.fetch(:method, nil)
        url = config.fetch(:url, nil)
        data = config.fetch(:data, nil) # data 和 body 一回事
        params = config.fetch(:params, nil)
        headers = {
          'x-authing-sdk-version': "ruby:#{AuthingRuby::VERSION}",
          'x-authing-userpool-id': @options.fetch(:userPoolId, ''),
          'x-authing-request-from': @options.fetch(:requestFrom, 'sdk'),
          'x-authing-app-id': @options.fetch(:appId, ''),
          'x-authing-lang': @options.fetch(:lang, ''),
        };

        # 如果用户传了 authorization 进来。
        config_headers_authorization = config.dig(:headers, :authorization)
        if config_headers_authorization != nil
          headers['Authorization'] = config_headers_authorization
        else
          # 如果用户不传 token，就使用 sdk 自己维护的。
          token = @tokenProvider.getToken() if @tokenProvider
          headers['Authorization'] = "Bearer #{token}" if token
        end

        resp = faraday_conn({
          method: method,
          params: params,
          url: url,
          data: data,
          headers: headers,
        })

        # const { code, message } = data;
        # if (code !== 200) {
        #   this.options.onError(code, message, data.data);
        #   throw new Error(JSON.stringify({ code, message, data: data.data }));
        # }
        # return data.data;

        return resp
      end

    end

    # JS SDK 里
    # NaiveHttpClient 和 HttpClient 的区别:  HttpClient 会处理 onError 回调函数，也会从返回的 data 中处理 code, message
    # NaiveHttpClient 只返回 data，也不带请求头 Authorization
    class NaiveHttpClient < HttpClient
      def initialize(options = {}, tokenProvider = nil)
        super(options, tokenProvider)
      end
    
      def request(config = {})
        headers = {
          'x-authing-sdk-version': "ruby:#{AuthingRuby::VERSION}",
          'x-authing-userpool-id': @options.fetch(:userPoolId, ''),
          'x-authing-request-from': @options.fetch(:requestFrom, 'sdk'),
          'x-authing-app-id': @options.fetch(:appId, ''),
          'x-authing-lang': @options.fetch(:lang, ''),
        };
        headers_merge = headers.merge(config.fetch(:headers, {}))
        # 先把 header 合并一下，把用户传进来的和这里默认的合并一下

        config = config.merge({headers: headers_merge})
        # 再把 config 处理一下，把最终 header 合并进去

        return faraday_conn(config)
      end
    end

  end
end

=begin
JS SDK 中调用 httpClient 的使用示例，在 vscode 中搜索 this.httpClient.request 可以找到

第一种：简单 get
  const data = await this.httpClient.request({
    method: 'GET',
    url: api
  });

第二种：简单 post
  const data = await this.httpClient.request({
    method: 'POST',
    url: api,
    data: { phone }
  });

第三种：post 加数据
  await this.httpClient.request({
    method: 'POST',
    url: `${this.baseClient.appHost}/api/v2/users/link`,
    data: {
      primaryUserToken: options.primaryUserToken,
      secondaryUserToken: options.secondaryUserToken
    }
  });

第四种: withCredentials
  await this.httpClient.request({
    method: 'GET',
    url: `${this.baseClient.appHost}/api/v2/logout?app_id=${this.options.appId}`,
    withCredentials: true
  });


# 第五种：params
  const data: IMfaAuthenticators = await this.httpClient.request({
    method: 'GET',
    url: api,
    params: {
      type,
      source
    },
    headers
  });
    

结论：需要支持以下参数：method, url, data, params，headers
method, url, headers 很好理解

params 是用于 get 方法的 url 参数
  // `params` are the URL parameters to be sent with the request
  // Must be a plain object or a URLSearchParams object
  params: {
    ID: 12345
  },

data 是
  // `data` is the data to be sent as the request body
  // Only applicable for request methods 'PUT', 'POST', 'DELETE , and 'PATCH'
  // When no `transformRequest` is set, must be of one of the following types:
  // - string, plain object, ArrayBuffer, ArrayBufferView, URLSearchParams
  // - Browser only: FormData, File, Blob
  // - Node only: Stream, Buffer
  data: {
    firstName: 'Fred'
  },

=end