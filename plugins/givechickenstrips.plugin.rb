class RandomNumberGenerator
	def initialize(bot)
		@bot = bot
	end

	def start
		while true
			sleep (rand(30..90)*60)
			@bot.handlers.dispatch(:gold_egg, nil, Kernel.rand)
		end
	end
end

class GiveGoldenEgg
	include Cinch::Plugin

	listen_to :gold_egg
	def listen(m, number)
		Channel("#fedoracoin").action "gives chisefu a strip of chicken"
	end
end
