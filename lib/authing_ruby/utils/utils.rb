# 一些工具函数放这里

require 'openssl'
require "base64"
require 'jwt'

module AuthingRuby
  class Utils
    # 参照 JS SDK 的 encrypt 函数
    # https://github.com/Authing/authing.js/blob/cf4757d09de3b44c3c3f4509ae8c8715c9f302a2/src/lib/utils.ts#L12
    # 用途：传入一个明文，传入一个公钥
    # 用这个公钥对明文进行 RSA 加密，
    # 然后返回 base64 编码后的结果
    def self.encrypt(plainText, publicKey)
      key = OpenSSL::PKey::RSA.new(publicKey)
      result = key.public_encrypt(plainText)
      return Base64.encode64(result)
    end

    # 生成随机字符串，参照 JS SDK 里的 src/lib/utils.ts
    def self.generateRandomString(length = 30)
      result = ""
      chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
      for i in 0..length-1
        random_index = rand(0..chars.length-1)
        result += chars[random_index]
      end
      return result
    end

    # 生成一个纯数字的随机字符串
    def self.randomNumberString(length = 8)
      result = ""
      chars = '0123456789'
      for i in 0..length-1
        random_index = rand(0..chars.length-1)
        result += chars[random_index]
      end
      return result
    end

    # verifyIDTokenHS256 函数用于验证 HS256 id_token

    # 文档：使用指南 -> 常见问题 -> 如何验证用户身份凭证（token） -> 使用应用密钥验证 HS256 算法签名的 Token
    # https://docs.authing.cn/v2/guides/faqs/how-to-validate-user-token.html#%E4%BD%BF%E7%94%A8%E5%BA%94%E7%94%A8%E5%AF%86%E9%92%A5%E9%AA%8C%E8%AF%81-hs256-%E7%AE%97%E6%B3%95%E7%AD%BE%E5%90%8D%E7%9A%84-token

    # 官方文档目前（2021-5-13）是让用户自己处理 HS256 的 token，自己进行验证，但这样比较麻烦，我在 Ruby SDK 这边写一个方便的方法。
    # verifyIDTokenHS256 返回 Boolean, true 代表 token 有效，false 代表无效

    # 注意: 可以在 "应用 -> 授权 -> id_token 签名算法" 这里看到，选的是不是 HS256
    # 如果是 HS256 才应该用这个方法来验证

    # 参数 id_token 就是登录返回的 "token"
    # 参数 appSecret 就是 Authing 里某个应用的 appSecret
    def self.verifyIDTokenHS256(id_token, appSecret)
      # 如果解码出错，直接返回 false
      begin
        hmac_secret = appSecret
        decoded = JWT.decode id_token, hmac_secret, true, { algorithm: 'HS256' }
      rescue => error
        # puts error.message
        return false
      end

      payload = decoded[0]
      header = decoded[1]

      # 从 payload 获得过期时间，然后判断是否过期
      exp = payload["exp"] # 过期时间
      current_timestamp = Time.now.to_i
      if current_timestamp < exp
        return true # 没过期
      else
        return false # 过期了
      end
    end

    # decodeIdToken 函数用于 解码 id token 得到用户信息
    # 因为 id token 其实就是一个普通的 JWT，所以 payload 没有加密过，只是 base64 编码了而已，可以当做明文看待 (你可以直接把 id token 粘贴到 https://jwt.io/ 看到 payload 内容）
    # 所以 payload 不可以直接相信，必须先验证后才能相信。
    # 函数返回：
    # 成功：返回用户信息
    # 失败：返回 nil （比如解码失败 或 token 过期）
    def self.decodeIdToken(id_token, appSecret)
      # 如果解码出错，直接返回 false
      begin
        hmac_secret = appSecret
        decoded = JWT.decode id_token, hmac_secret, true, { algorithm: 'HS256' }
      rescue => error
        # puts error.message
        return nil
      end

      payload = decoded[0]
      header = decoded[1]

      # 从 payload 获得过期时间，然后判断是否过期
      exp = payload["exp"] # 过期时间
      current_timestamp = Time.now.to_i
      if current_timestamp < exp
        return payload # 没过期
      else
        return nil # 过期了
      end
    end

  end
end