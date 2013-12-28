require 'cinch'
require 'curb-fu'
require_relative '../include/coinslot.singleton.rb'

class Difficulty
	include Cinch::Plugin
	match /getdifficulty/
	match /diff/
	
	set :help, <<-HELP
!getdifficulty
	Shows the current difficulty
!diff
	Shows the current difficulty
	HELP
	
	def execute(m)
		return if not CoinSlot.instance.check_coinslot(m)
		
		response = CurbFu.get('http://fedorachain.info/chain/Fedora/q/getdifficulty')
		
		m.reply response.body
	end
end
