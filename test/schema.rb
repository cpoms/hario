ActiveRecord::Schema.define(:version => 1) do
  create_table :brands, :force => true do |t|
    t.column :name, :string
    t.timestamps null: false
  end

  create_table :products, :force => true do |t|
    t.column :name, :string
    t.column :category_id, :integer
    t.column :brand_id, :integer
    t.column :hidden_column, :integer
    t.timestamps null: false
  end

  create_table :product_categories, :force => true do |t|
    t.column :name, :string
  end
end