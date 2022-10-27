class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :foodname, :ingredients, :servings, :country, :rating, :image, :description, :instructions
end
