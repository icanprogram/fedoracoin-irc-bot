require 'cinch'
require 'curb-fu'
require_relative '../include/coinslot.singleton.rb'

class BlockCount
	include Cinch::Plugin
	match /getblockcount/
	match /blocks/
	
	set :help, <<-HELP
!getblockcount
	Shows the current block number
!blocks
	Shows the current block number
	HELP
	
	def execute(m)
		#return if not CoinSlot.instance.check_coinslot(m)
		
		response = CurbFu.get('http://chain.fedoraco.in/chain/FedoraCoin/q/getblockcount')
		
		if response.status.between?(200, 299)
			m.reply response.body
		else
			m.reply "Sorry, there was an error with the request"
		end
	end
end
