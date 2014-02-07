require 'curb-fu'

module BalanceHelper
	def get_balance address
		response = CurbFu.get("http://chain.fedoraco.in/chain/FedoraCoin/q/addressbalance/#{address}")
		
		if response.status.between?(200, 299)
			response.body
		else
			"Sorry, there was an error with the request"
		end
	end
	
	def get_receivedbyaddress address
		response = CurbFu.get("http://chain.fedoraco.in/chain/FedoraCoin/q/getreceivedbyaddress/#{address}")
		
		if response.status.between?(200, 299)
			response.body
		else
			"Sorry, there was an error with the request"
		end
	end
end
