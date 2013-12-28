require 'cinch'
require 'curb-fu'
require 'json'
require_relative '../include/coinslot.singleton.rb'

class NetworkHash
	include Cinch::Plugin
	match /hashrate/
	
	set :help, <<-HELP
!hashrate
	Displays the current network hashrate
	HELP
	
	def execute(m)
		return if not CoinSlot.instance.check_coinslot(m)
		
		response = CurbFu.get('http://fedoracore.x64.me/index.php?page=api&action=public')
		ret = JSON.parse(response.body)
		
		prefixes = ["k", "M", "G", "T", "P", "E", "Z", "Y"]
		
		prefix = ""
		unit = "h/s"
		value = ret['network_hashrate'].to_f
		
		while value > 1000
			value = value/1000
			prefix = prefixes.shift
		end
		
		value = value.round(2)
		
		m.reply "The current network hashrate is #{value} #{prefix}#{unit}"
	end
end
