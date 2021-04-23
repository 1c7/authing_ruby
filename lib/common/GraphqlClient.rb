# TODO：做一个发 HTTP 请求的函数
# 主要是复刻 request 的部分
# 模仿
# https://github.com/Authing/authing.js/blob/cf4757d09de3b44c3c3f4509ae8c8715c9f302a2/src/lib/common/GraphqlClient.ts#L6
# 必须要这个是因为发请求要带上 'x-authing-userpool-id' 和 'x-authing-app-id 等 Header

# import { SDK_VERSION } from '../version';
require "http"

module Common
	class GraphqlClient
		# init()

		def request(options)
			headers = {
				'content-type': 'application/json',
				'x-authing-sdk-version': `js:${SDK_VERSION}`,
				'x-authing-userpool-id': this.options.userPoolId || '',
				'x-authing-request-from': this.options.requestFrom || 'sdk',
				'x-authing-app-id': this.options.appId || '',
				'x-authing-lang': this.options.lang || ''
			};
		end

	end
end