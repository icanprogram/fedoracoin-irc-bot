require 'cinch'
require 'curb-fu'
require 'json'

class ExchangeRate
	include Cinch::Plugin
	match /rate/
	match /exchanges/
	match /ticker/
	match /price/
	
	set :help, <<-HELP
!rate
	Shows the latest trade on coinedup
!exchanges
	Shows the latest trade on coinedup
!ticker
	Shows the latest trade on coinedup
!price
	Shows the latest trade on coinedup
	HELP
	
	def execute(m)
		response = CurbFu.get('http://192.168.1.100/coins/coinedup.php')
		trade = JSON.parse(response.body)
		
		time = Time.at(trade['timestamp'].to_i).utc
		
		if trade['curr'] == "BTC"
			trade['price'] = (trade['price'].to_f * (10**8)).round
			trade['curr'] = "satoshi"
		end
		
		m.reply "Latest trade on CoinedUp: #{trade['amount']}@#{trade['price']}#{trade['curr']} on #{time}"
	end
end