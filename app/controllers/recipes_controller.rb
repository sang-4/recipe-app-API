class RecipesController < ApplicationController

rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

    def index
        recipe = Recipe.all
        render json: @recipes, status: :ok

        #  respond_to do |format|
        #     format.html
        #     format.csv { render text: @recipes.to_csv }
        # end
    end
    

    def show
        recipe = Recipe.find(params[:id])
        render json: @recipe, status: :ok
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

    def record_not_found
        render json: {message: "Recipe not found"}, status: 404
    end

    def record_invalid
        render json: {message: "Validation error"}, status: 422
    end
end
