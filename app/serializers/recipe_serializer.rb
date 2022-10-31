class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :foodname, :ingredients, :servings, :country, :rating,  :description, :instructions, :image
end
