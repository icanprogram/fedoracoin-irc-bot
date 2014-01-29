require 'cinch'
require 'curb-fu'
require 'json'
require_relative 'hashrateformatter.helper.rb'
require_relative '../include/coinslot.singleton.rb'

class NetworkHash
	include Cinch::Plugin
	match /hashrate/
	
	include HashrateFormatter
	
	set :help, <<-HELP
!hashrate
	Displays the current network hashrate
	HELP
	
	def execute(m)
		#return if not CoinSlot.instance.check_coinslot(m)
		
		response = CurbFu.get('http://chickenstrips.net//index.php?page=api&action=public')
		ret = JSON.parse(response.body)
		
		hashrate = format_hashrate(ret['network_hashrate'])
		
		m.reply "The current network hashrate is #{hashrate}"
	end
end
