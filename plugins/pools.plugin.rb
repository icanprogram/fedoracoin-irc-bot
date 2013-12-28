require 'cinch'
require 'curb-fu'
require 'json'
require_relative '../include/coinslot.singleton.rb'

class Pools
	include Cinch::Plugin
	match /pools/
	
	set :help, <<-HELP
!pools
	Shows currently active pools (maintained by Cephon)
	HELP
	
	def execute(m)
		return if not CoinSlot.instance.check_coinslot(m)
		
		response = CurbFu.get('http://cphn.ml/res/pools.json')
		pools = JSON.parse(response.body)
		
		m.reply "I know about the following pools (list maintained by Cephon on cphn.ml)"
		pools.each do |pool|
			verified = pool['verified'] ? "yes" : "no"
			m.reply "\t#{pool['name']}: fee #{pool['fee']}%, verified: #{verified}, url: #{pool['url']}"
		end
		m.reply "end"
	end
end
