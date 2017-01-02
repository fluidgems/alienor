# encoding: UTF-8

# rb2g2 - object.rb

module Alienor

	class CoreObject
		#~ name : name of the object
		#~ source : the source object which contains global information
		#~ info : other infos
		
		include Indentation
		
		attr_accessor :name, :info, :source, :nb_indent

		class << self
			# here, put methods for a dictionnary ?
		end
		
		def initialize (name, source, info = {})
			@name = name
			@source = source
			@info = info
		end
		
		# make a string from a template
		# dname is an optional  path
		def template (tpl_name, dname = "")
			name = File.join @source.paradigm_name, "templates", dname, tpl_name
			t = ERB.new File.read("#{name}.erb"), nil, '-' # trim_mode
			t.result(binding)
		end
		
		# make a file in the root directory from a template
		# dname is an optional  path (same for the template and the generated file)
		def template_to_file (tpl_name, fname, dname = "")
			fw = File.open File.join(@source.root, dname, fname), "w"
			fw.puts template tpl_name, dname
			fw.close
		end
	end
end