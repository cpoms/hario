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

    assert_equal 3, products.count
  end

  def test_invalid_attribute_raises
    filters = { 'foobar.equals' => "ehehehe" }

    assert_raises Hario::FilterParser::InvalidAttributeError do
      Product.search(filters)
    end
  end

  def test_is_null
    filters = { 'brand_id.is' => "null" }

    products = Product.search(filters)
    assert_equal 1, products.count
    assert_equal 'Nil product', products.first.name
  end

  def test_is_not_null
    filters = { 'brand_id.is' => "not_null" }

    products = Product.search(filters)
    assert_equal 3, products.count
    products.each do |p|
      refute_equal 'Nil product', p.name
    end
  end

  def test_is_value_must_be_correct
    filters = { 'brand_id.is' => "meh" }

    assert_raises Hario::FilterParser::InvalidValueError do
      Product.search(filters)
    end
  end

  def test_hidden_column_filter
    filters = { 'hidden_column.equals' => 5 }

    assert_raises Hario::FilterParser::InvalidAttributeError do
      Product.search(filters)
    end
  end

  def test_hidden_column_filter_with_join
    filters = { 'products.hidden_column.equals' => 5 }

    assert_raises Hario::FilterParser::InvalidAttributeError do
      Brand.search(filters)
    end
  end
end