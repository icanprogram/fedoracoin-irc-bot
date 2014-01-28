require 'singleton'
require_relative '../plugins/getbalance.helper.rb'
 
class CoinSlot
	include Singleton
	include BalanceHelper

	def initialize
		# Total balance this bot has gotten
		@balance = get_receivedbyaddress(bot_address).to_i
		@timer = Thread.new{
			# Reset every two hours
			while true do
				@balance = get_receivedbyaddress(bot_address).to_i
				sleep(2 * 60 * 60)
			end
		}
	end
	
	def check_coinslot m
		left = needed_balance
		if left <= 0
			return true
		else
			m.action_reply "is out of euphoria!"
			m.reply "I need #{left} TIPS at #{bot_address} to get re-enlightened"
			return false
		end
	end
	
	private
	
	def needed_balance
		# This is called mid hour
		donations = get_receivedbyaddress(bot_address).to_i - @balance.to_i
		
		return minimum - donations
	end
	
	def bot_address
		"EfNdnZNBGcCGB8UgcJppuSpCE9o3rQFLCn"
	end
	
	def minimum
		0
	end
end
