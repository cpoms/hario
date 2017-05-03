require_relative 'test_helper'

class PluckTest < Hario::Test
  def test_simple_pluck
    brands = Brand.search(nil, ["name"])

    assert_equal ["id", "name"], brands.flat_map(&:keys).uniq,
        "Pluck not returning correct attributes"
  end

  def test_pluck_through_association
    # TODO: fix this so that it returns the association_name.attribute as
    # the hash key, rather than table_name.attribute (different to input)
    products = Product.search(nil, ["name", "brand.name"])

    assert_equal ["id", "name", "brands.name"], products.flat_map(&:keys).uniq,
        "Pluck not returning correct attributes with association pluck"
  end

  def test_hidden_column_pluck
    assert_raises Hario::PluckParser::InvalidAttributeError do
      Product.search(nil, %w( hidden_column ))
    end
  end

  def test_hidden_column_pluck_with_join
    assert_raises Hario::PluckParser::InvalidAttributeError do
      Brand.search(nil, %w( products.hidden_column ))
    end
  end

  def test_empty_string_ignored
    Product.search(nil, [""])

    # no exception
    assert true
  end
end
