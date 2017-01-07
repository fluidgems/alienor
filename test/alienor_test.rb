# encoding: UTF-8

# author : Reynald Bouy
# copyright 2017 Reynald Bouy
# ALIENOR - alienor_test.rb

require 'test_helper'
GENERATED_PATH = "test/generated"
PARADIGM_PATH = "test/paradigm"

class Something # test context imbrication
class AlienorTest < Minitest::Test
  include Alienor
  
  describe "version" do
    it "has a version number" do
      VERSION.must_equal "0.1.2"
    end
  end
  
  class Source < CoreSource
    self.dictionnaries = []
    attr_accessor :app_name
    def initialize  (app_name, app_title)
      super(GENERATED_PATH, PARADIGM_PATH)
      @app_name = app_name
      @app_title = app_title
      describe
    end
  end

  class Group < CoreObject
    self.dictionnaries = []
    Source.define_branch :group
  end
  
  class Entity < CoreObject
    self.dictionnaries = []
    Group.define_branch :entity, Source # Entity has a global dictionnary
  end

  describe "models" do
    it "uses dictionnaries" do
      Source.get_dic.must_equal [:groups, :entities]
      Group.get_dic.must_equal [:entities]
    end
    it "creates a source" do
      s = Source.new "S1", "Source number 1"
      s.groups.must_equal({})
      s.entities.must_equal({})
      s.app_name.must_equal "S1"
    end
    it "creates a source and a group" do
      s = Source.new "S1", "Source number 1"
      g = s.group :g1, "g1", only: :admin, options: [:hello]
      g.entities.must_equal({})
      g.name.must_equal :g1
      g.hname.must_equal "g1"
      g.info[:only].must_equal :admin
      g.options.must_equal [:hello]
    end
    it "creates an entity" do
      s = Source.new "S1", "Source number 1"
      g = s.group :g1, "g1", only: :admin, options: [:hello]
      e = g.entity :e1, "e1"
      e.name.must_equal :e1
    end
    it "accepts 2 different groups and 2 different entities" do
      s = Source.new "S1", "Source number 1"
      s.group(:g1, "g1").entity(:e1, "e1")
      g = s.group(:g2, "g2")
      g.wont_be_nil
      g.entity(:e2, "e2").wont_be_nil
    end
    it "does not accept twice the same group or twice the same entity" do
      s = Source.new "S1", "Source number 1"
      s.group(:g1, "g1").entity(:e1, "e1")
      g = s.group(:g1, "g1")
      g.must_be_nil
      g = s.group(:g2, "g2")
      g.entity(:e1, "e1").must_be_nil
    end
    it "uses blocks" do
      s = Source.new "S1", "Source number 1"
      g = s.group :g1, "g1", only: :admin do |g|
        g.entity(:e1, "e1")
      end
      g.entities.wont_equal({})
    end
    it "knows source, parent and named parent" do
      s = Source.new "S1", "Source number 1"
      g = s.group :g1, "g1", only: :admin do |g|
        e = g.entity(:e1, "e1")
        e.source.name.must_equal :source
        e.parent.name.must_equal :g1
        e.group.name.must_equal :g1
      end
      g.source.name.must_equal :source
      g.parent.name.must_equal :source
    end
  end

  describe "initializer" do
    it "initializes" do
      class I1 < CoreInitializer
        setup "S1", GENERATED_PATH
        construct File.join(PARADIGM_PATH, "initials")
      end
    end
  end
end # AlienorTest
end # Something
