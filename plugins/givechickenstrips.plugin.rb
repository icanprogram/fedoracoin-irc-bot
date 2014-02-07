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
		texts = [
			"gives chisefu a strip of chicken and whispers something as he walks away",
			"gives chisefu a bucket full of chicken strips mumbling something about emptying left-over supply",
			"gives chisefu a suspicious looking strip of chicken",
			"gives chisefu a strip of chicken. You get the feeling something big is coming.",
			"gives chisefu a strip of chicken. He nervously looks at before completing the transaction.",
			"gives chisefu a strip of chicken. As he does so, you get an uneasy feeling.",
			"gives chisefu something glittering. It went too fast to see but it looked like an egg?!?!",
			"starts to give chisefu something but quickly runs away when he sees you looking.",
			"starts to give chisefu something but quickly runs away when he sees you looking.",
			"starts to give chisefu something but quickly runs away when he sees you looking.",
			"gives chisefu a strip of chicken",
			"gives chisefu a strip of chicken",
			"gives chisefu a strip of chicken",
			"gives chisefu a strip of chicken"
		]
		Channel("#TIPS").action texts.sample
	end
end
