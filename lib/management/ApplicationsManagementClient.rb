

module AuthingRuby	
  class ApplicationsManagementClient
		
		def initialize(options = {}, httpClient, graphqlClient, tokenProvider)
			@options = options;
			@httpClient = httpClient;
			@graphqlClient = graphqlClient;
			@tokenProvider = tokenProvider;
			# this.acl = new AclManagementClient(
			# 	options,
			# 	graphqlClient,
			# 	httpClient,
			# 	tokenProvider
			# );
			# this.roles = new RolesManagementClient(
			# 	options,
			# 	graphqlClient,
			# 	tokenProvider
			# );
			# this.agreements = new AgreementManagementClient(
			# 	options,
			# 	graphqlClient,
			# 	httpClient,
			# 	tokenProvider
			# );
		end

		def list(page = 1, limit = 10)
			data = @httpClient.request({
				method: 'GET',
				url: "#{@options.fetch(:host, nil)}/api/v2/applications",
				data: {
					"page": page,
					"limit": limit
				}
			});
			return data;
		end

		# 创建应用
		def create(options = {})
			result = @httpClient.request({
				method: 'POST',
				url: "#{@options.fetch(:host, nil)}/api/v2/applications",
				data: {
					"name": options.fetch(:name, nil),
					"identifier": options.fetch(:identifier, nil),
					"redirectUris": options.fetch(:redirectUris, nil),
					"logo": options.fetch(:logo, nil),
				}
			});
			return result;
		end

		# 删除应用
		def delete(appid)
			url = "#{@options.fetch(:host, nil)}/api/v2/applications/#{appid}"
			result = @httpClient.request({
				method: 'DELETE',
				url: url,
			});
			return result
		end


	end
end