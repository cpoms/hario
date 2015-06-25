require 'minitest/autorun'
require_relative 'test_helper'

class FilterTest < Minitest::Test
  def setup
    @brand = Brand.create!(name: "Adidas")
  end

  def teardown
    Brand.delete_all
  end

  def test_simple_filter
    filters = { 'name.equals' => "Adidas" }
    brands = Brand.search(filters)

    assert !brands.any?{|b| b.name != "Adidas" }
  end
end