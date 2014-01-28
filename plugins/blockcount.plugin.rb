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
		
		response = CurbFu.get('http://fedorachain.info/chain/Fedora/q/getblockcount')
		
		m.reply response.body
	end
end
