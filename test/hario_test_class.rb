require "minitest/autorun"

class Hario::Test < Minitest::Unit::TestCase
  def teardown
    DatabaseRewinder.clean
  end
end