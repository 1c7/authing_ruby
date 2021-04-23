# https://github.com/Authing/authing.js/blob/196b33fe0c7f510ca26cda4d172939e1c74cc5f7/src/lib/authentication/BaseAuthenticationClient.ts

module Authentication
	class BaseAuthenticationClient
		def initialize(options = {})
			@options = options
		end

		def appHost()
			# 最新版本，传入 appHost
			appHost = @options.fetch(:appHost, nil)
			return appHost if appHost != nil
			# TODO: 用 regex 去掉 appHost 最后的斜杠 "/" (如果有的话)
			
			# 兼容协议认证 API 中传入的 domain
			domain = @options.fetch(:domain, nil)
			if domain != nil
				return "https://#{domain}";
			end

			# 最后使用服务器统一域名 host
			host = @options.fetch(:host, 'https://core.authing.cn')
			return host
		end
	end
end