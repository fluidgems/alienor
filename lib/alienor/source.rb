# encoding: UTF-8

# rb2g2 - source.rb

module Alienor

	class CoreSource < CoreObject
		
		#~ @root : generation path
		#~ @paradigm_name : paradigm name
		
		attr_accessor :root, :paradigm_name
			
		def initialize (root = GENERATED_PATH, info = {})
			super(:source, self)
			@paradigm_name = PARADIGM_PATH
			@root = root
		end
		
		def describe
		end
		
		def generate
		end
		
	end

end