
module Test
	class Helper
		# 随机字母字符串，默认8位长度
		def randomString(length = 8)
			endIndex = length % 26
			('a'..'z').to_a.shuffle[0,endIndex].join
		end

		# 随机数字字符串
		def randomNumString(n = 6)
			srand.to_s.chars.last(n).join
		end
	end
end