# encoding: UTF-8

# author : Reynald Bouy
# copyright 2017 fluidgems
# ALIENOR - source.rb

module Alienor

	class CoreSource < CoreObject
		
		#~ @root : generation path
		#~ @paradigm_name : paradigm name
		
		attr_accessor :root, :paradigm_name
			
		def initialize (root, paradigm_name)
			super(:source, "", self, self)
			@root = root
			@paradigm_name = paradigm_name
		end
		
		def describe
		end
		
		def generate
		end
		
	end

end