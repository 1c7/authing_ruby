# 用途：把一个字符串通过 RSA 公钥进行加密
# 把这个加密后的字符串，传递给 Authing 的 registerbyemail 的 muation 的 password 字段
# 如何运行: ruby ./lib/test/RSA.rb

# 2021-4-24 结论：这个能运行，但是暂时不确定传递给  Authing 是否能用，要先解决用户池id 的问题
# https://github.com/Authing/authing.js/blob/cf4757d09de3b44c3c3f4509ae8c8715c9f302a2/src/lib/common/GraphqlClient.ts#L6
# 用户池 id 是请求头里 'x-authing-userpool-id' 指定的
# 解决了，实测可以，这个公钥加密方式是正确的。可以用这个密码登录。

require 'openssl'
require "base64"

# 公钥来自 https://rails-demo.authing.cn/api/v2/.well-known
public_key = "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC4xKeUgQ+Aoz7TLfAfs9+paePb\n5KIofVthEopwrXFkp8OCeocaTHt9ICjTT2QeJh6cZaDaArfZ873GPUn00eOIZ7Ae\n+TiA2BKHbCvloW3w5Lnqm70iSsUi5Fmu9/2+68GZRH9L7Mlh8cFksCicW2Y2W2uM\nGKl64GDcIq3au+aqJQIDAQAB\n-----END PUBLIC KEY-----\n"
key = OpenSSL::PKey::RSA.new(public_key)
str = "password112233"
result = key.public_encrypt(str)
puts Base64.encode64(result)  # 如果不 encode 64 就直接输出，命令行会看到乱码
