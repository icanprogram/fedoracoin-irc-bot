require 'cinch'
require 'curb-fu'

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
		response = CurbFu.get('http://fedorachain.info/chain/Fedora/q/getblockcount')
		
		m.reply response.body
	end
end
