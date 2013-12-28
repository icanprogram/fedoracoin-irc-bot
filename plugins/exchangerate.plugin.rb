require 'cinch'
require 'curb-fu'
require 'json'
require_relative '../include/coinslot.singleton.rb'

class ExchangeRate
	include Cinch::Plugin
	match /rate$/, method: :last_trade
	match /exchanges$/, method: :last_trade
	match /ticker$/, method: :last_trade
	match /price$/, method: :last_trade
	
	match /rate ([0-9]+)$/, method: :worth
	match /exchanges ([0-9]+)$/, method: :worth
	match /ticker ([0-9]+)$/, method: :worth
	match /price ([0-9]+)$/, method: :worth
	
	set :help, <<-HELP
!rate [amount]
	Shows the latest trade on coinedup, worth of amount if specified
!exchanges [amount]
	Shows the latest trade on coinedup, worth of amount if specified
!ticker [amount]
	Shows the latest trade on coinedup, worth of amount if specified
!price [amount]
	Shows the latest trade on coinedup, worth of amount if specified
	HELP
	
	def last_trade(m)
		return if not CoinSlot.instance.check_coinslot(m)
		
		trade = get_last_trade
		
		time = Time.at(trade['timestamp'].to_i).utc
		
		m.reply "Latest trade on CoinedUp: #{trade['amount']}@#{trade['price']}#{trade['curr']} on #{time}"
	end
	
	def worth(m, amount)
		return if not CoinSlot.instance.check_coinslot(m)
		
		trade = get_last_trade
		
		total = (amount * trade['price']).to_f
		
		if trade['curr'] == "satoshi"
			if total >= 1000000
				total = (total / (10**8))
				trade['curr'] = "BTC"
			end
		end
		
		total = total.round(2)
		
		m.reply "#{total}#{trade['curr']}"
	end
	
	def get_last_trade
		response = CurbFu.get('http://192.168.1.100/coins/coinedup.php')
		trade = JSON.parse(response.body)
		
		if trade['curr'] == "BTC"
			price = trade['price'].to_f
			if price < 0.00001
				#Convert to satoshi
				trade['price'] = (price * (10**8)).round
				trade['curr'] = "satoshi"
			end
		end
		
		trade
	end
end