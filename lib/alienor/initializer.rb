# encoding: UTF-8

# Alienor - initializer.rb

module Alienor
  #~ require 'FileUtils' # redundant ?

  class CoreInitializer
    
    class << self
      def setup (app_name, root)
        @app_name = app_name
        @root = root
      end

      def construct(src)
        puts "initializing... with #{src}"
        
        # rename index.html if necessary
        target_dir = File.join @root, "public"
        if File.exist? index_file = File.join(target_dir, "index.html")
          File.rename index_file, File.join(target_dir, "index_0.html")
          puts "renaming index.html"
        end
        
        # copy all files recursively
        FileUtils.cp_r File.join(src, "."), @root
      end
    end
  end
end
