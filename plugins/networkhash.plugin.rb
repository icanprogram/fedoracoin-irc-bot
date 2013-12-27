require 'cinch'
require 'curb-fu'
require 'json'

class NetworkHash
	include Cinch::Plugin
	match /hashrate/
	
	set :help, <<-HELP
!hashrate
	Displays the current network hashrate
	HELP
	
	def execute(m)
		response = CurbFu.get('http://fedoracore.x64.me/index.php?page=api&action=public')
		ret = JSON.parse(response.body)
		
		#TODO: Auto stepping
		m.reply "The current network hashrate is #{ret['network_hashrate']/1000000}MH/s"
	end
end
