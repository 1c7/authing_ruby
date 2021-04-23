require 'openssl'
require "base64"

# 参照 JS SDK 的 encrypt 函数
# https://github.com/Authing/authing.js/blob/cf4757d09de3b44c3c3f4509ae8c8715c9f302a2/src/lib/utils.ts#L12
def encrypt(plainText, publicKey)
	key = OpenSSL::PKey::RSA.new(public_key)
	result = key.public_encrypt(plainText)
	return Base64.encode64(result)
end