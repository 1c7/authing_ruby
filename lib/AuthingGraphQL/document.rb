module AuthingGraphQL
	module Document

		# AuthingGraphQL::Document.schema
		def self.schema
			<<-'GRAPHQL'
      {
        __schema {
          types {
            name
          }
        }
      }
    	GRAPHQL
		end

		# AuthingGraphQL::Document.RegisterByEmailDocument
	  def self.RegisterByEmailDocument
			return <<-'GRAPHQL'
				mutation registerByEmail($input: RegisterByEmailInput!) {
					registerByEmail(input: $input) {
						id
						arn
						userPoolId
						status
						username
						email
						emailVerified
						phone
						phoneVerified
						unionid
						openid
						nickname
						registerSource
						photo
						password
						oauth
						token
						tokenExpiredAt
						loginsCount
						lastLogin
						lastIP
						signedUp
						blocked
						isDeleted
						device
						browser
						company
						name
						givenName
						familyName
						middleName
						profile
						preferredUsername
						website
						gender
						birthdate
						zoneinfo
						locale
						address
						formatted
						streetAddress
						locality
						region
						postalCode
						city
						province
						country
						createdAt
						updatedAt
						externalId
					}
				}
			GRAPHQL
		end

    def self.registerByUsername
			return <<-'GRAPHQL'
				mutation registerByUsername($input: RegisterByUsernameInput!) {
					registerByUsername(input: $input) {
						id
						arn
						userPoolId
						status
						username
						email
						emailVerified
						phone
						phoneVerified
						unionid
						openid
						nickname
						registerSource
						photo
						password
						oauth
						token
						tokenExpiredAt
						loginsCount
						lastLogin
						lastIP
						signedUp
						blocked
						isDeleted
						device
						browser
						company
						name
						givenName
						familyName
						middleName
						profile
						preferredUsername
						website
						gender
						birthdate
						zoneinfo
						locale
						address
						formatted
						streetAddress
						locality
						region
						postalCode
						city
						province
						country
						createdAt
						updatedAt
						externalId
					}
				}
			GRAPHQL
		end


	end
end