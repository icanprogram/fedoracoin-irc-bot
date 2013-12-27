require 'cinch'
require 'curb-fu'

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
		response = CurbFu.get('http://fedorachain.info/chain/Fedora/q/getdifficulty')
		
		m.reply response.body
	end
end
