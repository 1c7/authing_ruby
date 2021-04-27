# 复刻一个 JS SDK 里的 ManagementTokenProvider
# 方法名字，返回值，参数的数量和顺序，都尽量保持一致。
# authing.js/src/lib/management/ManagementTokenProvider.ts
# https://github.com/Authing/authing.js/blob/fad3b5ba03de36968422f23971b281dbb7de2187/src/lib/management/ManagementTokenProvider.ts#L6

module AuthingRuby
	class ManagementTokenProvider

		def initialize(options = {}, graphqlClient = nil)
			@options = options;
			@graphqlClient = graphqlClient;
	
			accessToken = options.fetch(:accessToken, nil)
			if accessToken
				@_accessToken = accessToken;
				# JS  里这一段没看懂， *1000 是什么意思？
				# exp 是啥？
				# TODO: 整一个 jwtdecode 
				# const decoded: DecodedAccessToken = jwtDecode(accessToken);
				# const { exp } = decoded;
				# this._accessTokenExpriredAt = exp * 1000;
			end
		end

		# TODO
		# 得先把这个做了, users.create 才能用
		def getToken()
			accessToken = @options.fetch(:accessToken, nil)
			return accessToken if accessToken
			# // 缓存到 accessToken 过期前 3600 s
			# if (
			# 	this._accessToken &&
			# 	this._accessTokenExpriredAt > new Date().getTime() + 3600 * 1000
			# ) {
			# 	return this._accessToken;
			# }
			return _getAccessTokenFromServer();
		end

		def _getAccessTokenFromServer
			# // 如果是通过密钥刷新
			# let accessToken = null;
			# if (this.options.secret) {
			# 	accessToken = await this.getClientWhenSdkInit();
			# } else {
			# 	accessToken = await this.refreshToken();
			# }
	
			# this._accessToken = accessToken;
			# const decoded: DecodedAccessToken = jwtDecode(this._accessToken);
			# const { exp } = decoded;
			# this._accessTokenExpriredAt = exp * 1000;
			# return this._accessToken;
		end

		# TODO
		def getClientWhenSdkInit
		end

		# TODO
		def refreshToken
		end

	end
end