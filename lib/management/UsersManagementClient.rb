# https://github.com/Authing/authing.js/blob/master/src/lib/management/UsersManagementClient.ts

module AuthingRuby
	class UsersManagementClient

		def initialize(options, graphqlClient, httpClient, tokenProvider, publickKeyManager)
			@options = options.fetch(:options, nil)
			@graphqlClient = options.fetch(:graphqlClient, nil)
			@tokenProvider = options.fetch(:tokenProvider, nil)
			@httpClient = options.fetch(:httpClient, nil)
			@publickKeyManager = options.fetch(:publickKeyManager, nil)
		end

		# TODO
		# 创建用户
		# 代码参考: https://github.com/Authing/authing.js/blob/master/src/lib/management/UsersManagementClient.ts#L99
		def create(userInfo, options = {})
			keepPassword = options.fetch(:keepPassword, false)
			# if (userInfo?.password) {
			# 	userInfo.password = await this.options.encryptFunction(
			# 		userInfo.password,
			# 		await this.publickKeyManager.getPublicKey()
			# 	);
			# }
			# const { createUser: user } = await createUser(
			# 	this.graphqlClient,
			# 	this.tokenProvider,
			# 	{
			# 		userInfo,
			# 		keepPassword
			# 	}
			# );
			# return user;
		end

		# TODO
		# 修改用户资料
		# 代码参考 https://github.com/Authing/authing.js/blob/master/src/lib/management/UsersManagementClient.ts#L189
		def update
		end

		# TODO
		def detail
		end

		# TODO
		def delete(userId)
		end

		# TODO
		def deleteMany(userIds = [])
		end

		# TODO
		# 批量获取用户
		def batch
		end
		
		# TODO
		# 获取用户列表
		def list
		end

		# 检查用户是否存在
		def exists
		end

		# TODO
		def search
		end

		# TODO
		def refreshToken
		end

	end
end