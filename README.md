# Hario

Hario provides ActiveRecord filtering for Rails APIs.

## Installation

Add this line to your application's Gemfile:

    gem 'hario'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hario

## Usage

# Setup

Add `include Hario::Filterable` to your AR model to add the `search` method, for instance (we'll use these classes as examples throughout):

```ruby
def Brand < ActiveRecord::Base
  include Hario::Filterable

  has_many :products
end

def Product < ActiveRecord::Base
  belongs_to :brand
  belongs_to :category, class_name: "ProductCategory"
end

def ProductCategory < ActiveRecord::Base
  has_many :products
end
```

Then in your BrandsController you can use the `search` method in your index action:

```ruby
class BrandsController < ApplicationController
  respond_to :json

  def index
    @brands = Brand.search(params[:filters])

    respond_with(@brands)
  end
end
```

# Filters

The format of `params[:filters]`'s keys is a dot-seperated chain of association(s) -> attribute -> operator, for instance if you wanted to return brands that have products of type "Shoe" you could add the filter:

```ruby
{ 'products.category.name.equals' => 'Shoe' }
```

Which would result in the SQL query something like:

```sql
SELECT "brands".* FROM "brands"
INNER JOIN "products" ON "products"."brand_id" = "brands"."id"
INNER JOIN "product_categories" ON "product_categories"."id" = "products"."category_id"
WHERE "product_categories"."name" = 'Shoe'
```

The available operators are:

- lt (less than)
- gt (greater than)
- lte (less than or equal)
- gte (greater than or equal)
- like (sql like)
- equals

## Todo

- Migrate our application-specific tests across to the gem

## Contributing

1. Fork it ( https://github.com/[my-github-username]/hario/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
