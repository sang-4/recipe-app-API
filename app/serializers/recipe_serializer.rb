class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :name, :ingredients, :servings, :country, :rating, :image, :description, :instructions
end
