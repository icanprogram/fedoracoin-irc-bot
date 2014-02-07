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
		#return if not CoinSlot.instance.check_coinslot(m)
		
		response = CurbFu.get('http://chain.fedoraco.in/chain/FedoraCoin/q/getdifficulty')
		
		if response.status.between?(200, 299)
			m.reply response.body
		else
			m.reply "Sorry, there was an error with the request"
		end
	end
end
