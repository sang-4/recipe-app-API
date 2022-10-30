class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :name, :ingredients, :num_of_pple_served, :country, :rating
end
