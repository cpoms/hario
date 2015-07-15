require "minitest/autorun"

class Hario::Test < Minitest::Test
  def teardown
    DatabaseRewinder.clean
  end
end