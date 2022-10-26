class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :foodname
      t.string :ingredients
      t.integer :servings
      t.string :country
      t.integer :rating
      t.string :image
      t.string :description
      t.string :instructions

      t.timestamps
    end
  end
end
