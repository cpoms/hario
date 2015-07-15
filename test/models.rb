require 'hario'

class Brand < ActiveRecord::Base
  extend Hario::Filterable

  has_many :products
end

class Product < ActiveRecord::Base
  extend Hario::Filterable

  belongs_to :brand
  belongs_to :category, class_name: "ProductCategory"
end

class ProductCategory < ActiveRecord::Base
  has_many :products
end