require 'cinch'

class Nodes
	include Cinch::Plugin
	match /nodes/, method: :nodes
	match /config/, method: :config
	
	set :help, <<-HELP
!nodes
	Displays some nodes
!config
	Outputs the entire config. Be considerate, run this in a privmsg.
	HELP
	
	def get_nodes
		["79.168.129.77:22889", "83.248.33.223:22889", "81.108.29.80:22889", "67.191.189.132:22889", "95.105.116.189:22889", "122.149.136.199:22889", "50.202.110.30:22889", "212.198.177.53:22889"]
	end
	
	def nodes(m)
		m.reply get_nodes.join(" ")
	end
	
	def config(m)
		get_nodes.each do |node|
			m.reply "addnode=#{node}"
		end
	end
end
