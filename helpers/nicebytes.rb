# encoding: utf-8
module NiceBytes
	K = 2.0**10
	M = 2.0**20
	G = 2.0**30
	T = 2.0**40
	def nice_bytes( bytes, max_digits=3 )
		value, suffix, precision = case bytes
			when 0...K
				[ bytes, 'B', 0 ]
			else
				value, suffix = case bytes
					when K...M then [ bytes / K, 'kiB' ]
					when M...G then [ bytes / M, 'MiB' ]
					when G...T then [ bytes / G, 'GiB' ]
					else            [ bytes / T, 'TiB' ]
				end
				used_digits = case value
					when   0...10   then 1
					when  10...100  then 2
					when 100...1000 then 3
					else 4
				end
				leftover_digits = max_digits - used_digits
				[ value, suffix, leftover_digits > 0 ? leftover_digits : 0 ]
		end
		"%.#{precision}f#{suffix}" % value
	end
	module_function :nice_bytes
end
