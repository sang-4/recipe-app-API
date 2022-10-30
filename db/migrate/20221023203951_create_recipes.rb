class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :ingredients
      t.integer :num_of_pple_served
      t.string :country
      t.integer :rating

      t.timestamps
    end
  end
end
