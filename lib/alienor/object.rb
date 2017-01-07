# encoding: UTF-8

# author : Reynald Bouy
# copyright 2017 fluidgems
# ALIENOR - object.rb

module Alienor

  class CoreObject
    include Indentation
    
    class_attribute :dictionnaries
    
    self.dictionnaries = []
    
    class << self
    
      def add_dictionnary(dic_name)
        attr_accessor dic_name
        self.dictionnaries << dic_name
      end
      
      def get_dic
        #~ p "in #{self}"
        self.dictionnaries
      end
      
      # dynamic operations for a "branch" of this object
      # global is the source class if this branch is "global" (meaning Source will hold a dictionnary for this branch)
      def define_branch(x, global = nil)
        this_class_name = self.name.split('::')[-1]
        
        # compute context + x, eg Something::AlienorTest::Group
        this_context = self.name.split('::')[0..-2].join('::')
        x_class = (this_context == "") ? x.to_s.camelize : "#{this_context}::#{x.to_s.camelize}"
        
        # dictionnary name
        x_dic_name = x.to_s.pluralize # eg groups, entities
        
        # create dictionnary for that branch
        add_dictionnary x_dic_name.to_sym # eg :groups
        
        # create global dictionnary if global
        eval(global.name).add_dictionnary x_dic_name.to_sym if global # eg :entities
        
        # define method that creates new objects of a certain entity, eg def group(...)
        define_method "#{x}" do |name, hname, info={}, &block|
          conflict = eval("#{x}_conflict(name)") # this entry already exists
          obj = eval(x_class).new name, hname, self, source, info
          eval("@#{x_dic_name}")[name] = obj # feed parent dictionnary
          eval("@source.#{x_dic_name}")[name] = obj if global # feed source dictionnary if global
          block.call(obj) if block # block for creating other objects. Warning : yield(obj) if block_given? would not work here because within a define_method
          conflict ? nil : obj
        end
        
        # define method that evaluates conflict depending on branch being global or not
        # can be redefined if necessary
        define_method "#{x}_conflict" do |name|
          global ? eval("@source.#{x_dic_name}")[name] : eval("@#{x_dic_name}")[name]
        end
        
        # call named_parent definition in child class
        eval(x_class).define_named_parent this_class_name unless this_class_name == "Source"

      end
      
      # define a meaningful alias for method returning parent
      # eg if Entity is a branch of Group, this will define in class Entity : def group; @parent; end
      def define_named_parent(parent_class_name)
        #~ p "parent_class_name : #{parent_class_name}"
        define_method parent_class_name.underscore do
          @parent
        end
      end
    
    end
    
    attr_accessor :name, :hname, :info, :options, :parent, :source, :nb_indent

    # name : name of the object
    # hname : human name of the object
    # source : the source object which contains global information
    # info : optional infos, and options if any
    def initialize(name, hname, parent, source, info = {})
      init_dics
      @name = name
      @hname = hname
      @parent = parent
      @source = source
      @info = info
      @options = info[:options]
    end
    
    def init_dics
      self.dictionnaries.each do |d|
        self.instance_variable_set "@#{d}", {}
      end
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