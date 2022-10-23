# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
#users seeding
#comments seeding 
puts "Seeding..."

Comment.create([
    {user_id:1,content:"my son and I have used this app repeatedly and has greatly improved our cooking skills,cant get enought of your recipes.Thank you!",image_url:"https://domf5oio6qrcr.cloudfront.net/medialibrary/11537/4a78f148-d427-4209-8173-f33d04c44106.jpg"},
    {user_id:2,content:"Am surprised how cooking has become so easy,this app has techmically saved my marriage",image_url:"https://img.freepik.com/free-photo/african-woman-is-cutting-yellow-pepper-kitchen-desk-table-are-products-from-supermarket_8353-10248.jpg?w=1380&t=st=1666525353~exp=1666525953~hmac=c16dcc54e3c53c30a6814b3d62c20cfd66cce1168b91681492acbdefe144203b"},
    {user_id:3,content:"every recipe is dope, thanks you i can now say goodbye to my delivery man",image_url:"https://img.freepik.com/free-photo/women-preparing-together-romantic-dinner_23-2149063565.jpg?w=1380&t=st=1666525468~exp=1666526068~hmac=6683c95f65c8fc7b1a497cf4916ea7bca8aef8e18e9c56f98e182183c156c5a7reepik.com/free-photo/attractive-young-african-american-housewife-beige-dress-standing-kitchen-with-utensils-wooden-spoon-having-pensive-facial-expression-thinking-what-cook-dinner-cuisine-food_343059-2648.jpg?w=1380&t=st=1666525401~exp=1666526001~hmac=9a50735262988dd298d98896341a0e092abfa47f792b7f7a72bed99e23f28ecc"},
    {user_id:4,content:"cant wait to host a party",image_url:"https://img.freepik.com/free-photo/woman-chef-cooking-vegetables-pan_1303-22291.jpg?w=1380&t=st=1666525426~exp=1666526026~hmac=2a6d3905ee6c69c98ed3a32c987b5f851d841e0a6316f27cddfc107fa921b438"}

])
puts "Seeding done."