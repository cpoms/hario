require 'date'

@adidas = Brand.create!(name: "Adidas")
@shoe = ProductCategory.create!(name: "Shoe")
@tee = ProductCategory.create!(name: "T-shirt")

Product.create!(
  brand_id: @adidas.id,
  category_id: @shoe.id,
  name: "Gazelle OG",
  created_at: DateTime.now - 10
)
Product.create!(
  brand_id: @adidas.id,
  category_id: @shoe.id,
  name: "Hamburg"
)
Product.create!(
  brand_id: @adidas.id,
  category_id: @tee.id,
  name: "Hamburg"
)