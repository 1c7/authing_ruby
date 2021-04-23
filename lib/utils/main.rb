require 'openssl'
require "base64"

module Utils
	# 参照 JS SDK 的 encrypt 函数
	# https://github.com/Authing/authing.js/blob/cf4757d09de3b44c3c3f4509ae8c8715c9f302a2/src/lib/utils.ts#L12
	# 用途：传入一个明文，传入一个公钥
	# 用这个公钥对明文进行 RSA 加密，
	# 然后返回 base64 编码后的结果
	def encrypt(plainText, publicKey)
		key = OpenSSL::PKey::RSA.new(publicKey)
		result = key.public_encrypt(plainText)
		return Base64.encode64(result)
	end
	module_function :encrypt
end