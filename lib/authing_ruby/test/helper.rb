
module Test
	class Helper
		# 随机字母字符串，默认 6 位长度
		def randomString(length = 6)
			endIndex = length % 26
			('a'..'z').to_a.shuffle[0,endIndex].join
		end

		# 随机数字字符串
		def randomNumString(n)
			result = []
			n.to_i.times do
				result << [0,1,2,3,4,5,6,7,8,9].sample
			end
			result.join
		end
	end
end