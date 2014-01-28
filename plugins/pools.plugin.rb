require 'cinch'
require 'curb-fu'
require 'json'

class Pools
	include Cinch::Plugin
	match /pools/
	
	set :help, <<-HELP
!pools
	Shows currently active pools (maintained by Cephon)
	HELP
	
	def execute(m)
		response = CurbFu.get('http://fedoraco.in/pools.php')
		pools = JSON.parse(response.body)
		
		m.reply "I know about the following pools (list maintained by tipsfedora on fedoraco.in)"
		pools.each do |pool|
			verified = pool['verified'] ? "yes" : "no"
			m.reply "\t#{pool['name']}: fee #{pool['fee']}%, verified: #{verified}, url: #{pool['url']}"
		end
		m.reply "end"
	end
end
