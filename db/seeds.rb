# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
#users seeding
#comments seeding 

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


puts "Seeding done."