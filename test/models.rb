require 'hario'

class Brand < ActiveRecord::Base
  include Hario::Filterable

  has_many :products
end

class Product < ActiveRecord::Base
  belongs_to :brand
  belongs_to :category, class_name: "ProductCategory"
end

class ProductCategory < ActiveRecord::Base
  has_many :products
end