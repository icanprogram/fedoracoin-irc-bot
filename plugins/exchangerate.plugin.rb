require 'cinch'
require 'curb-fu'
require 'json'
require_relative '../include/coinslot.singleton.rb'

class ExchangeRate
	include Cinch::Plugin
	match /rate(?:$| (ltc|btc)$)/, method: :last_trade
	match /exchanges(?:$| (ltc|btc)$)/, method: :last_trade
	match /ticker(?:$| (ltc|btc)$)/, method: :last_trade
	match /price(?:$| (ltc|btc)$)/, method: :last_trade
	
	match /rate (?:|(ltc|btc) )([0-9]+)$/, method: :worth
	match /exchanges (?:|(ltc|btc) )([0-9]+)$/, method: :worth
	match /ticker (?:|(ltc|btc) )([0-9]+)$/, method: :worth
	match /price (?:|(ltc|btc) )([0-9]+)$/, method: :worth
	
	set :help, <<-HELP
!rate [ltc|btc|null] [amount]
	Shows the latest trade on coinedup, worth of amount if specified
!exchanges [ltc|btc|null] [amount]
	Shows the latest trade on coinedup, worth of amount if specified
!ticker [ltc|btc|null] [amount]
	Shows the latest trade on coinedup, worth of amount if specified
!price [ltc|btc|null] [amount]
	Shows the latest trade on coinedup, worth of amount if specified
	HELP
	
	def last_trade(m, type)
		return if not CoinSlot.instance.check_coinslot(m)
		type = "BTC" if type.nil?
		type.upcase!
		
		trade = get_last_trade type
		
		time = Time.at(trade['timestamp'].to_i).utc
		
		m.reply "Latest trade on CoinedUp: #{trade['amount']}@#{trade['price']}#{trade['curr']} on #{time}"
	end
	
	def worth(m, type, amount)
		return if not CoinSlot.instance.check_coinslot(m)
		type = "BTC" if type.nil?
		type.upcase!
		
		trade = get_last_trade type
		
		total = (amount.to_i * trade['price']).to_f
		
		if trade['curr'][0,7]  == "satoshi"
			if total >= 10000
				total = (total / (10**8))
				trade['curr'] = trade['curr'][8,3]
			end
		end
		
		total = total.round(2)
		
		m.reply "#{total}#{trade['curr']}"
	end
	
	def get_last_trade type
		response = CurbFu.get("http://192.168.1.100/coins/coinedup.php?type=#{type}")
		trade = JSON.parse(response.body)
		
		if trade['curr'] == "BTC" or trade['curr'] == "LTC"
			price = trade['price'].to_f
			if price < 0.00001
				#Convert to satoshi
				trade['price'] = (price * (10**8)).round
				trade['curr'] = "satoshi #{trade['curr']}"
			end
		end
		
		trade
	end
end