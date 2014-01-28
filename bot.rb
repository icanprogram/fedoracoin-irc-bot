require 'cinch'
root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(root + '/plugins/*.plugin.rb', &method(:require))

bot = Cinch::Bot.new do
	configure do |c|
		c.user = "ProgramBot"
		c.nick = "ProgramBot"
		c.realname = "ProgramBot"
		c.server = "irc.freenode.org"
		c.channels = ["#fedoracoin", "#TIPS"]
		c.plugins.plugins = [NetworkHash, Pools, BlockCount, Difficulty, AddressBalance, ExchangeRate, Credits, Help, GiveGoldenEgg, Nodes]
	end
end

Thread.new { RandomNumberGenerator.new(bot).start }

bot.start
