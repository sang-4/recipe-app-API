# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
#users seeding
#comments seeding 
require 'rest-client'
require 'faker'

puts "Seeding."

50.times do
    User.create(
        firstname: Faker::Name.first_name,
        lastname: Faker::Name.last_name,
        username: Faker::Internet.username,
        email: Faker::Internet.email,
        password: "password",
        password_confirmation: "password"
    )
end

# seeding recipes

# def results_dataset
#     results = RestClient.get("https://recipes.eerieemu.com/api/recipe/?format=json")
#     results_array = JSON.parse(results)
#     results_array.each do |r|
#         Recipe.create(
#             foodname: r["name"],
#             ingredients: r["ingredients"],
#             servings: r["servings"],
#             country: r["country"],
#             rating: r["rating"],
#             image_path: r["image_path"],
#             description: r["description"],
#             instructions: r["instructions"]
#         )
#     end
# end
# results_dataset()


puts "Seeding done."



