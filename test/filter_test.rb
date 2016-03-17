require_relative 'test_helper'
require 'date'

class FilterTest < Hario::Test
  def test_test_data_loaded_properly
    assert Brand.count > 0,
      "Test data not loaded"
  end

  def test_simple_filter
    filters = { 'name.equals' => "Adidas" }
    brands = Brand.search(filters)

    assert !brands.any?{ |b| b.name != "Adidas" }
  end

  def test_filter_with_join
    filters = { 'products.name.equals' => "Gazelle OG" }
    brands = Brand.search(filters)

    assert_equal 1, brands.count
    assert brands.first.name == "Adidas"
  end

  def test_filter_with_double_join
    filters = {
      'products.category.name.equals' => "T-shirt",
      'products.name.equals' => "Hamburg"
    }
    brands = Brand.search(filters)
    brand = brands.first

    assert_equal 1, brands.count
    assert brand.name == "Adidas"
  end

  def test_filter_with_date_condition
    filters = { 'created_at.gt' => (DateTime.now - 5).iso8601 }
    products = Product.search(filters)

    assert_equal 2, products.count
  end

  def test_invalid_attribute_raises
    filters = { 'foobar.equals' => "ehehehe" }

    assert_raises Hario::FilterParser::InvalidAttributeError do
      Product.search(filters)
    end
  end
end