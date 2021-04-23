require "http"
require "./lib/AuthingGraphQL/document.rb"
require './lib/utils/main.rb'
require './lib/common/PublicKeyManager.rb'
require './lib/common/GraphqlClient.rb'

class AuthingRuby
  # a = AuthingRuby.new({appHost: "https://rails-demo.authing.cn"})
  # a.pk
  def initialize(options = {})
    @publicKeyManager = Common::PublicKeyManager.new(options)
  end
  def pk
    puts @publicKeyManager.getPublicKey()
  end
  
  def self.hi
    puts "Hello world!"
  end

  # 例子: 发一个简单的 GraphQL 请求
  # 用法：AuthingRuby.graph
  def self.graph
    # 写法1
    query1 = <<-'GRAPHQL'
      {
        __schema {
          types {
            name
          }
        }
      }
    GRAPHQL

    # 写法2
    query2 = <<~EOF
      {
        __schema {
          types {
            name
          }
        }
      }
    EOF
    response = HTTP.post('https://core.authing.cn/graphql', json: {
      # "query": query1,
      # "query": query2,
      "query": AuthingGraphQL::Document.schema
    })
    puts response.body.to_s # https://github.com/httprb/http/wiki/Response-Handling
  end
end


class AuthingRuby::AuthenticationClient
  def initialize(options = {})
    @options = options
    @appId = options.fetch(:appId, nil) # 应用 ID
    # https://docs.authing.cn/v2/guides/faqs/get-app-id-and-secret.html
    # 如何获取应用 ID (AppID) 和应用密钥（AppSecret）
    # appHost 是 该应用的域名（AppHost），如 https://my-awesome-app.authing.cn
    # appHost 的获取方法：某用户池 -> 应用 -> 基础设置 -> 认证地址
    if @appId == nil
      # 提示 appId 是个必须的参数
    end

    @secret = options.fetch(:secret, nil) # 应用密钥
    @appHost = options.fetch(:appHost, nil) # 该应用的域名
    @redirectUri = options.fetch(:redirectUri, nil) # 业务回调地址
    @authing_graphql_endpoint = 'https://core.authing.cn/graphql'

    # 公钥加密
    @publicKeyManager = Common::PublicKeyManager.new(options)

    # 负责发送 GraphQL (其实就是 http) 请求的工具
    graphqlEndpoint = "#{@appHost}/graphql/v2";
    @graphqlClient = Common::GraphqlClient.new(graphqlEndpoint, @options)
  end

  # 使用邮箱+密码注册 (完成, 测试通过)
  # 参照: https://docs.authing.cn/v2/reference/sdk-for-node/authentication/AuthenticationClient.html
  # a = AuthingRuby::AuthenticationClient.new({appHost: "https://rails-demo.authing.cn", appId: "60800b9151d040af9016d60b"})
  # a.registerByEmail('301@qq.com', "123456789")
  def registerByEmail(email, password, profile = {}, options = {})
    publicKey = @publicKeyManager.getPublicKey()
    encryptedPassword = Utils.encrypt(password, publicKey)
    variables = {
      "input": {
        "email": email,
        "password": encryptedPassword,
      }
    }
    json = {
      "query": AuthingGraphQL::Document.RegisterByEmailDocument,
      "variables": variables,
    }
    response = @graphqlClient.request({json: json})
    return response
  end

  # 使用邮箱登录
  def loginByEmail()
    # TODO
  end

  # 使用用户名注册
  def registerByUsername(username, password, profile, options)
    # TODO
  end

end

# 管理模块
class AuthingRuby::ManagementClient
  # TODO
end