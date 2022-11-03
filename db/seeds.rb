require 'rest-client'

puts "Seeding."

# 50.times do
#     User.create(
#         firstname: Faker::Name.first_name,
#         lastname: Faker::Name.last_name,
#         username: Faker::Internet.username,
#         email: Faker::Internet.email,
#         password: "password",
#         password_confirmation: "password"
#     )
# end

# puts "Seeding done."

# seeding recipes

puts 'Now 🌱  seeding recipes...'

response = RestClient.get("https://recipes.eerieemu.com/api/recipe/?format=json")
recipes = JSON.parse(response)  

recipes = recipes["results"]

recipes.map do |recipe|
    new_recipe = Recipe.create(
        foodname: recipe["name"],
        image: recipe["image_path"],
        description: recipe["description"], 
        ingredients: recipe["ingredients"], 
        instructions: recipe["instructions"],
        country: Faker::Address.country,
        servings: recipe["servings"], 
        rating: recipe["rating_value"],
    )
end

puts "✅ Done seeding!"



