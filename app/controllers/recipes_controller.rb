class RecipesController < ApplicationController
    def index
        recipe = Recipe.all
        render json: @recipes, status: :ok
    end

    def show
        recipe = Recipe.find(params[:name, :ingredients, :num_of_pple_served])
        render json: @recipes, status: :ok
    end

    def create
        puts JSON.pretty_generate(recipe_params)
        new_recipe = Recipe.create!(recipe_params)
        render json: new_recipe, status: :created
    end

    def update
        @recipe = Recipe.find(params[:id])
        @recipe.update(recipe_params)
        render json: @recipe, status: 200
    end

    def destroy
        @recipe = Recipe.find(params[:id])
        @recipe.destroy
        render json: {message: "Recipe deleted"}, status: 200
    end

    private
    def recipe_params
        params.require(:recipe).permit(:id, :name, :ingredients, :num_of_pple_served, :country, :rating)
    end
end
