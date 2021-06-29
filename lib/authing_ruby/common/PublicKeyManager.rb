# PublicKeyManager 负责获取公钥
# 模仿的是：
# https://github.com/Authing/authing.js/blob/cf4757d09de3b44c3c3f4509ae8c8715c9f302a2/src/lib/common/PublicKeyManager.ts#L28
# authing.js/src/lib/common/PublicKeyManager.ts 
require "http"
require_relative '../authentication/BaseAuthenticationClient.rb'

module AuthingRuby
  module Common
    class PublicKeyManager

      def initialize(options = {})
        @options = options
        @public_key = nil # 用于缓存公钥，免得每次都发请求
        @baseClient = Authentication::BaseAuthenticationClient.new(options)
      end
      
      def getPublicKey
        # 用传进来的 publicKey
        option_publicKey = @options.fetch(:publicKey, nil)
        return option_publicKey if option_publicKey != nil

        # 用缓存的 publickKey
        return @public_key if @public_key != nil

        # 发请求获取 publicKey
        appHost = @baseClient.appHost()
        url = "#{appHost}/api/v2/.well-known"

        begin
          response = HTTP.get(url)
        rescue HTTP::ConnectionError => e
          # 处理失败情况
          puts "authing_ruby gem 错误 HTTP::ConnectionError"
          puts "访问的 URL 是 #{url}"
          puts "如何解决：有可能是 appHost \"#{appHost}\" 填写错误，appHost 可能并不存在，请确认。"
          puts "第二种可能原因是您本地开启了 VPN，导致无法访问 \"#{appHost}\"，您可手动访问此网站进行确认。"
          raise e.class, "Message: #{e.message}"
          return
        end
        
        response_text = response.body.to_s
        # {"code":200,"message":"获取成功","data":{"publicKey":"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC4xKeUgQ+Aoz7TLfAfs9+paePb\n5KIofVthEopwrXFkp8OCeocaTHt9ICjTT2QeJh6cZaDaArfZ873GPUn00eOIZ7Ae\n+TiA2BKHbCvloW3w5Lnqm70iSsUi5Fmu9/2+68GZRH9L7Mlh8cFksCicW2Y2W2uM\nGKl64GDcIq3au+aqJQIDAQAB\n-----END PUBLIC KEY-----\n"}}
        
        json = JSON.parse(response_text)
        publicKey = json['data']['publicKey']
        @public_key = publicKey # 存入缓存
        return publicKey
      end

    end
  end
end