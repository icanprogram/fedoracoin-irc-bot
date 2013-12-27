require 'cinch'
require 'curb-fu'
require_relative 'getbalance.helper.rb'

class Credits
	include Cinch::Plugin
	match /credits/
	
	include BalanceHelper
	
	set :help, <<-HELP
!credits
	Show who built this bot
	HELP
	
	def execute(m)
		m.reply "This bot was built by icanprogram"
		m.reply "\tYou can tip him at #{dev_address}"
		m.reply "\tHe's gotten #{get_balance(dev_address)} TIPs"
	end
	
	def dev_address
		"EbNyjRyLXaw4ZVXywndGnySTyad3Kq2w2L"
	end
end
