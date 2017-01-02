require 'test_helper'

class AlienorTest < Minitest::Test
	include Alienor
  def test_that_it_has_a_version_number
    refute_nil VERSION
		
		#~ puts "version: #{VERSION}"
		
		assert_equal VERSION, "0.1.0"
  end

  def test_it_does_something_useful
    #~ assert false
		
		x = CoreObject.new "toto"
		assert_equal x.name, "toto"
  end
end
