require 'hario'

class Brand < ActiveRecord::Base
  include Hario::Filterable
end