require 'hario'

class Brand < ActiveRecord::Base
  extend Hario::Filterable

  has_many :products
end

class Product < ActiveRecord::Base
  extend Hario::Filterable

  hario_attributes [:filters, :pluck], except: :hidden_column

  belongs_to :brand
  belongs_to :category, class_name: "ProductCategory"
end

class ProductCategory < ActiveRecord::Base
  has_many :products
end