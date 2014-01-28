require 'cinch'
require 'curb-fu'
require_relative 'getbalance.helper.rb'
require_relative '../include/coinslot.singleton.rb'

class AddressBalance
	include Cinch::Plugin
	match /addressbalance (E[1-9A-Za-z][^OIl]{20,40})/
	match /balance (E[1-9A-Za-z][^OIl]{20,40})/
	
	include BalanceHelper
	
	set :help, <<-HELP
!addressbalance <address>
	Gets the current (confirmed) balance of an address
!balance <address>
	Gets the current (confirmed) balance of an address
	HELP
	
	def execute(m, address)
		#return if not CoinSlot.instance.check_coinslot(m)
		
		m.reply get_balance(address)
	end
end
