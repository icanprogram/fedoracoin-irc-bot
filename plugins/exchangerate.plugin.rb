require 'cinch'
require 'curb-fu'
require 'json'
require_relative '../include/coinslot.singleton.rb'

class ExchangeRate
	include Cinch::Plugin
	match /rate(?:$| (ltc|doge)$)/, method: :last_trade
	match /exchanges(?:$| (ltc|doge)$)/, method: :last_trade
	match /ticker(?:$| (ltc|doge)$)/, method: :last_trade
	match /price(?:$| (ltc|doge)$)/, method: :last_trade
	
	match /rate (?:|(ltc|doge) )([0-9]+)$/, method: :worth
	match /exchanges (?:|(ltc|doge) )([0-9]+)$/, method: :worth
	match /ticker (?:|(ltc|doge) )([0-9]+)$/, method: :worth
	match /price (?:|(ltc|doge) )([0-9]+)$/, method: :worth
	
	set :help, <<-HELP
!rate [ltc|doge|null] [amount]
	Shows the latest trade on coinedup, worth of amount if specified
!exchanges [ltc|doge|null] [amount]
	Shows the latest trade on coinedup, worth of amount if specified
!ticker [ltc|doge|null] [amount]
	Shows the latest trade on coinedup, worth of amount if specified
!price [ltc|doge|null] [amount]
	Shows the latest trade on coinedup, worth of amount if specified
	HELP
	
	def last_trade(m, type)
		#return if not CoinSlot.instance.check_coinslot(m)
		type = "LTC" if type.nil?
		type.upcase!
		
		trades = get_last_trades type
		
		trades.each do |exchange, trade|
			m.reply "Latest trade on #{exchange}: #{trade['amount']}@#{trade['price']}#{trade['curr']} on #{trade['time']}"
		end
	end
	
	def worth(m, type, amount)
		#return if not CoinSlot.instance.check_coinslot(m)
		type = "LTC" if type.nil?
		type.upcase!
		
		trade = process_trade(coinedup_to_trade(get_coinedup(type)))
		
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
	
	def process_trade trade
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
	
	def get_coinedup type
		response = CurbFu.get("http://192.168.1.100/coins/coinedup.php?type=#{type}")
		JSON.parse(response.body)
	end
	
	def get_cryptsy type
		if type == "LTC"
			begin
				response = CurbFu.get("http://pubapi.cryptsy.com/api.php?method=singlemarketdata&marketid=147")
				data = JSON.parse(response.body)['return']['markets']['TIPS']
				ret = data['recenttrades'][0]
				ret['curr'] = data['secondarycode']
				ret
			rescue
				ret = Hash.new
				ret['price'] = 0
				ret['quantity'] = 0
				ret['time'] = ""
				ret['secondarycode'] = "API is down"
				ret
			end
		else
			nil
		end
	end
	
	def coinedup_to_trade coinedup
		coinedup['time'] = Time.at(coinedup['timestamp'].to_i).utc
		coinedup
	end
	
	def cryptsy_to_trade cryptsy
		puts cryptsy.inspect
		trade = Hash.new
		trade['price'] = cryptsy['price']
		trade['amount'] = cryptsy['quantity']
		trade['time'] = cryptsy['time'] + " Cryptsy time"
		trade['curr'] = cryptsy['curr']
		trade
	end
	
	def get_last_trades type
		ret = Hash.new
		if type == "LTC"
			ret["CoinedUp"] = process_trade(coinedup_to_trade(get_coinedup(type)))
			ret["Cryptsy"] = process_trade(cryptsy_to_trade(get_cryptsy(type)))
		elsif type == "DOGE"
			ret["CoinedUp"] = process_trade(coinedup_to_trade(get_coinedup(type)))
		end
		ret
	end
	
	
end
