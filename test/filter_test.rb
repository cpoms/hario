require_relative 'test_helper'

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
end