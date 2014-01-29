module HashrateFormatter
	def format_hashrate hashrate
		prefixes = ["k", "M", "G", "T", "P", "E", "Z", "Y"]
		
		prefix = ""
		unit = "h/s"
		value = hashrate.to_f
		
		while value > 1000
			value = value/1000
			prefix = prefixes.shift
		end
		
		"#{value.round(2)} #{prefix}#{unit}"
	end
end
