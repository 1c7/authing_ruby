require "http"
require "./lib/AuthingGraphQL/document.rb"

class AuthingRuby
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
  def initialize(params = {})
    @appId = params.fetch(:appId, nil) # 应用 ID
    # https://docs.authing.cn/v2/guides/faqs/get-app-id-and-secret.html
    # 如何获取应用 ID (AppID) 和应用密钥（AppSecret）
    # appHost 是 该应用的域名（AppHost），如 https://my-awesome-app.authing.cn
    # appHost 的获取方法：某用户池 -> 应用 -> 基础设置 -> 认证地址
    if @appId == nil
      # 提示 appId 是个必须的参数
    end

    @secret = params.fetch(:secret, nil) # 应用密钥
    @appHost = params.fetch(:appHost, nil) # 该应用的域名
    @redirectUri = params.fetch(:redirectUri, nil) # 业务回调地址
    @authing_graphql_endpoint = 'https://core.authing.cn/graphql'
  end

  def getAccessTokenByCode(code)
  end

  # 使用邮箱注册
  # https://docs.authing.cn/v2/reference/sdk-for-node/authentication/AuthenticationClient.html
  # 返回值: Promise<User>
  def registerByEmail(email, password, profile, options)
    # TODO
    # 先从这个开始做起
    variables = {
      "registerByEmailInput": {
        "email": email,
        "password": "puQvy+Fk246Dz8c3+oFt+erGRRDNApketWDarbX2ZMTimtrBn7WmWaCgCdLdiovIx0tFvirxII4jvl3ouhh3DN79Xpa8CpuBYYcBI9ONW3e7D/VOC98mfHom3jAciKsaOdui1f3Dn/aDInDsIgL87jkR+IZFfUrftLM4l7TwqYc="
      }
    }
    # x-authing-userpool-id
    response = HTTP.headers('x-authing-userpool-id' => "x")
      .post(@authing_graphql_endpoint, json: {
      "query": AuthingGraphQL::Document.RegisterByEmailDocument,
      "variables": variables,
    })
    puts response.body.to_s
    # 剩下的步骤：
    # 1. 把 variables 构造一下
      # 1.1 需要用公钥把密码加密一下
      # 1.2 也需要写发请求并解析保存公钥的那个工具函数
    # 2. 在 http header 里指定用户池 id
    # 3. 实测一下发请求行不行
    # 4. 
  end
  # 使用邮箱密码注册
  # authenticationClient.registerByEmail('test@example.com', 'passw0rd')

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