require 'curb-fu'

module BalanceHelper
	def get_balance address
		response = CurbFu.get("http://fedorachain.info/chain/Fedora/q/addressbalance/#{address}")
		
		response.body
	end
	
	def get_receivedbyaddress address
		response = CurbFu.get("http://fedorachain.info/chain/Fedora/q/getreceivedbyaddress/#{address}")
		
		response.body
	end
end
