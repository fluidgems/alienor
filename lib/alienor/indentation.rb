# encoding: UTF-8

# rb2g2 / indentation.rb

module Alienor
	module Indentation
		
		def init_indent
			@source.nb_indent = 0
		end
		
		def indent
			@source.nb_indent += 1
		end
		
		def unindent
			@source.nb_indent -= 1
		end
		
		def add_line(r, s = "")
			r.replace(r + ("\t" * @source.nb_indent) + s + "\n")
		end
	end
end