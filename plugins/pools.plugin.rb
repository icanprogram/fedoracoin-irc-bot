require 'cinch'
require 'curb-fu'
require 'json'
require_relative 'hashrateformatter.helper.rb'

class PoolSoftware
	include HashrateFormatter

	def initialize base_url
		@base_url = base_url
	end

	def self.api_url
	end
	
	def getHashrate format
	end
	
	def getWorkers
	end
	
	def getNetHash format
	end
	
	def getNetperc
		"#{((getHashrate(false).to_f / getNethash(false).to_f)*100).round(2)}%"
	end
end

class MPOS < PoolSoftware
	def initialize base_url
		super(base_url)
		response = CurbFu.get(@base_url + MPOS.api_url)
		@pool_data = JSON.parse(response.body)
	end
	
	def self.api_url
		'/?page=api&action=public'
	end
	
	def getHashrate format
		format ? format_hashrate(@pool_data['hashrate'] * 1000) : @pool_data['hashrate'] * 1000
	end
	
	def getWorkers
		@pool_data['workers']
	end
	
	def getNethash format
		format ? format_hashrate(@pool_data['network_hashrate']) : @pool_data['network_hashrate']
	end
end

class Pool
	attr_reader :name, :url, :fee, :verified, :type, :owner
	
	def initialize(data)
		@name = data['name']
		@url = data['url']
		@fee = data['fee']
		@verified = data['verified']
		@type = data['type']
		@owner = data['owner']
		
		case data['software']
		when 'mpos'
			@software = MPOS.new @url
		else
			@software = MPOS.new @url
		end
	end
	
	def getPoolData
		@software
	end
end

class Pools
	include Cinch::Plugin
	match /pools$/, method: :execute
	match /pools details/, method: :details
	
	set :help, <<-HELP
!pools
	Shows currently active pools (maintained by tipsfedora)
!pools details
	Shows currently active pools with extra info
	HELP
	
	def getpools
		response = CurbFu.get('http://fedoraco.in/pools.php')
		JSON.parse(response.body)
	end
	
	def execute(m)
		m.reply "I know about the following pools (list maintained by tipsfedora on fedoraco.in)"
		getpools.each do |pool|
			verified = pool['verified'] ? "yes" : "no"
			m.reply "\t#{pool['name']}: fee #{pool['fee']}%, verified: #{verified}, url: #{pool['url']}, maintainer(s): #{pool['owner']}"
		end
		m.reply "end"
	end
	
	def details(m)
		m.reply "I know about the following pools (list maintained by tipsfedora on fedoraco.in)"
		getpools.each do |pool_data|
			begin
				p = Pool.new pool_data
				m.reply "\t#{p.name}: url: #{p.url}, #{p.getPoolData.getHashrate true} - #{p.getPoolData.getNetperc}, #{p.getPoolData.getWorkers} workers"
			rescue
				m.reply "\t#{pool_data['name']}'s API is not responding"
			end
		end
		m.reply "end"
	end
end
