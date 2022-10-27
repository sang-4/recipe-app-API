# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
#users seeding
#comments seeding 

# require 'faker'

# puts "Seeding."

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

# require 'rest-client'

puts "Seeding Recipes"

Recipe.create!(
    foodname: "Red Lentil Soup With Lemon",
    ingredients: [
        "3 tablespoons olive oil, more for drizzling",
        "1 large onion, chopped",
        "2 garlic cloves, minced",
        "1 tablespoon tomato paste",
        "1 teaspoon ground cumin",
        "1/4 teaspoon kosher salt, more to taste",
        "1/4 teaspoon ground black pepper",
        " Pinch of ground chile powder or cayenne, more to taste",
        "1 quart chicken or vegetable broth",
        "2 cups water",
        "1 cup red lentils",
        "1 large carrot, peeled and diced",
        " Juice of 1/2 lemon, more to taste",
        "3 tablespoons chopped fresh cilantro"
        ],
    servings: "4 servings",
    country: "Kenya",
    rating: "4",
    image: "",
    description: "This is a lentil soup that defies expectations of what lentil soup can be. Based on a Turkish lentil soup, mercimek corbasi, it is light, spicy and a bold red color (no murky brown here): a revelatory dish that takes less than an hour to make. The cooking is painless. Sauté onion and garlic in oil, then stir in tomato paste, cumin and chile powder and cook a few minutes more to intensify flavor. Add broth, water, red lentils (which cook faster than their green or black counterparts) and diced carrot, and simmer for 30 minutes. Purée half the mixture and return it to the pot for a soup that strikes the balance between chunky and pleasingly smooth. A hit of lemon juice adds an up note that offsets the deep cumin and chile flavors.",
    instructions: [
        "In a <a href='https://www.nytimes.com/wirecutter/reviews/best-dutch-oven/'>large pot</a>, heat 3 tablespoons oil over high heat until hot and shimmering. Add onion and garlic, and sauté until golden, about 4 minutes.",
        "Stir in tomato paste, cumin, salt, black pepper and chili powder or cayenne, and sauté for 2 minutes longer.",
        "Add broth, 2 cups water, lentils and carrot. Bring to a simmer, then partially cover pot and turn heat to medium-low. Simmer until lentils are soft, about 30 minutes. Taste and add salt if necessary.",
        "Using an immersion or regular blender or a food processor, purée half the soup then add it back to pot. Soup should be somewhat chunky.",
        "Reheat soup if necessary, then stir in lemon juice and cilantro. Serve soup drizzled with good olive oil and dusted lightly with chili powder if desired."
    ]
)

Recipe.create!(
    foodname: "Old-Fashioned Beef Stew",
    ingredients: [
        "1/4 cup all-purpose flour",
        "1/4 teaspoon freshly ground pepper",
        "1 pound beef stewing meat, trimmed and cut into inch cubes",
        "5 teaspoons vegetable oil",
        "2 tablespoons red wine vinegar",
        "1 cup red wine",
        "3 1/2 cups beef broth, homemade or low-sodium canned",
        "2 bay leaves",
        "1 medium onion, peeled and chopped",
        "5 medium carrots, peeled and cut into 1/4-inch rounds",
        "2 large baking potatoes, peeled and cut into 3/4-inch cubes",
        "2 teaspoons salt"
    ],
    servings: "4 servings",
    country: "Uganda",
    rating: "4",
    image: "",
    description: "This classic stick-to-your-ribs stew is the ideal project for a chilly weekend. Beef, onion, carrots, potatoes and red wine come together in  cozy harmony. If you are feeding a crowd, good news: It doubles (or triples) beautifully.",
    instructions: [
        "Combine the flour and pepper in a bowl, add the beef and toss to coat well. Heat 3 teaspoons of the oil in a <a href='https://www.nytimes.com/wirecutter/reviews/best-dutch-oven/'>large pot</a>. Add the beef a few pieces at a time; do not overcrowd. Cook, turning the pieces until beef is browned on all sides, about 5 minutes per batch; add more oil as needed between batches.",
        "Remove the beef from the pot and add the vinegar and wine. Cook over medium-high heat, scraping the pan with a wooden spoon to loosen any browned bits. Add the beef, beef broth and bay leaves. Bring to a boil, then reduce to a slow simmer.",
        "Cover and cook, skimming broth from time to time, until the beef is tender, about 1 1/2 hours. Add the onions and carrots and simmer, covered, for 10 minutes. Add the potatoes and simmer until vegetables are tender, about 30 minutes more. Add broth or water if the stew is dry. Season with salt and pepper to taste. Ladle among 4 bowls and serve."
    ]
)

Recipe.create!(
    foodname: "No-Knead Bread",
    ingredients: [
        "3 1/3 cups/430 grams all-purpose or bread flour, plus more for dusting",
        " Generous 1/4 teaspoon/1 gram instant yeast",
        "2 teaspoons/8 grams kosher salt",
        " Cornmeal or wheat bran, as needed"
    ],
    servings: "5 servings",
    country: "Burundi",
    rating: "4",
    image: "",
    description: "Here is one of the most popular recipes The Times has ever published, courtesy of Jim Lahey, owner of Sullivan Street Bakery. It requires no kneading. It uses no special ingredients, equipment or techniques. And it takes very little effort — only time. You will need 24 hours to create the bread, but much of this is unattended waiting, a slow fermentation of the dough that results in a perfect loaf. (We've updated the recipe to reflect <a href=\"https://www.nytimes.com/2006/12/06/dining/06mini.html\">changes Mark Bittman made</a> to the recipe in 2006 after publishing and receiving reader feedback. The original recipe called for 3 cups flour; we've adjusted it to call for 3 1/3 cups/430 grams flour.",
    instructions: [
        "In a large bowl combine flour, yeast and salt. Add 1 1/2 cups/345 grams water and stir until blended; dough will be shaggy and sticky. Cover bowl with plastic wrap. Let dough rest at least 12 hours, preferably about 18, at warm room temperature, about 70 degrees.",
        "Dough is ready when its surface is dotted with bubbles. Lightly flour a work surface and place dough on it; sprinkle it with a little more flour and fold it over on itself once or twice. Cover loosely with plastic wrap and let rest about 15 minutes.",
        "Using just enough flour to keep dough from sticking to work surface or to your fingers, gently and quickly shape dough into a ball. Generously coat a cotton towel (not terry cloth) with flour, wheat bran or cornmeal; put dough seam side down on towel and dust with more flour, bran or cornmeal. Cover with another cotton towel and let rise for about 2 hours. When it is ready, dough will be more than double in size and will not readily spring back when poked with a finger.",
        "At least a half-hour before dough is ready, heat oven to 450 degrees. Put a 6- to 8-quart heavy covered pot (cast iron, enamel, Pyrex or ceramic) in oven as it heats. When dough is ready, carefully remove pot from oven. Slide your hand under towel and turn dough over into pot, seam side up; it may look like a mess, but that is O.K. Shake pan once or twice if dough is unevenly distributed; it will straighten out as it bakes. Cover with lid and bake 30 minutes, then remove lid and bake another 15 to 30 minutes, until loaf is beautifully browned. Cool on a rack."
    ]
)

Recipe.create!(
    foodname: "Marcella Hazan’s Bolognese Sauce",
    ingredients: [
        "1 tablespoon vegetable oil",
        "3 tablespoons butter plus 1 tablespoon for tossing the pasta",
        "1/2 cup chopped onion",
        "2/3 cup chopped celery",
        "2/3 cup chopped carrot",
        "3/4 pound ground beef chuck (or you can use 1 part pork to 2 parts beef)",
        " Salt",
        " Black pepper, ground fresh from the mill",
        "1 cup whole milk",
        " Whole nutmeg",
        "1 cup dry white wine",
        "1 1/2 cups canned imported Italian plum tomatoes, cut up, with their juice",
        "1 1/4 to 1 1/2 pounds pasta",
        " Freshly grated parmigiano-reggiano cheese at the table"
    ],
    servings: "3 servings",
    country: "Kenya",
    rating: "5",
    image: "",
    description: "After the death in 2013 of Marcella Hazan, the cookbook author who changed the way Americans cook Italian food, The Times asked readers which of her recipes had become staples in their kitchens. Many people answered with one word: “Bolognese.” Ms. Hazan had a few recipes for the classic sauce, and they are all outstanding. This one appeared in her book “The Essentials of Classic Italian Cuisine,” and one reader called it “the gold standard.” Try it and see for yourself.",
    instructions: [
        "Put the oil, butter and chopped onion in the pot and turn the heat on to medium. Cook and stir the onion until it has become translucent, then add the chopped celery and carrot. Cook for about 2 minutes, stirring vegetables to coat them well.",
        "Add ground beef, a large pinch of salt and a few grindings of pepper. Crumble the meat with a fork, stir well and cook until the beef has lost its raw, red color.",
        "Add milk and let it simmer gently, stirring frequently, until it has bubbled away completely. Add a tiny grating -- about 1/8 teaspoon -- of nutmeg, and stir.",
        "Add the wine, let it simmer until it has evaporated, then add the tomatoes and stir thoroughly to coat all ingredients well. When the tomatoes begin to bubble, turn the heat down so that the sauce cooks at the laziest of simmers, with just an intermittent bubble breaking through to the surface. Cook, uncovered, for 3 hours or more, stirring from time to time. While the sauce is cooking, you are likely to find that it begins to dry out and the fat separates from the meat. To keep it from sticking, add 1/2 cup of water whenever necessary. At the end, however, no water at all must be left and the fat must separate from the sauce. Taste and correct for salt.",
        "Toss with cooked drained pasta, adding the tablespoon of butter, and serve with freshly grated Parmesan on the side."
    ]
)

Recipe.create!(
    foodname: "Caramelized Shallot Pasta",
    ingredients: [
        "1/4 cup olive oil",
        "6 large shallots, very thinly sliced",
        "5 garlic cloves, 4 thinly sliced, 1 finely chopped",
        " Kosher salt and freshly ground black pepper",
        "1 teaspoon red-pepper flakes, plus more to taste",
        "1 (2-ounce) can anchovy fillets (about 12), drained",
        "1 (4.5-ounce) tube or (6-ounce) can of tomato paste (about 1/2 to 3/4 cup)",
        "10 ounces pasta",
        "1 cup parsley, leaves and tender stems, finely chopped",
        " Flaky sea salt"
    ],
    servings: "6 servings",
    country: "Tanzania",
    rating: "3",
    image: "",
    description: "This pasta is all about the shallots, cooked down in a bath of olive oil to a jammy, caramelized paste. Tomato paste is there for tanginess, and anchovies for saltiness, but they serve more as background flavors to the sweetness of the shallot. This recipe makes enough caramelized shallot mixture for a double batch of pasta, or simply keep it refrigerated to spoon over fried eggs, or to serve underneath crispy chicken thighs or over roasted root vegetables like carrots or sweet potatoes.",
    instructions: [
        "Heat olive oil in a large heavy-bottomed <a href='https://www.nytimes.com/wirecutter/reviews/best-dutch-oven/'>Dutch oven</a> over medium high. Add shallots and thinly sliced garlic, and season with salt and pepper. Cook, stirring occasionally, until the shallots have become totally softened and caramelized with golden-brown fried edges, 15 to 20 minutes.",
        "Add red-pepper flakes and anchovies. (No need to chop the anchovies; they will dissolve on their own.) Stir to melt the anchovies into the shallots, about 2 minutes.",
        "Add tomato paste and season with salt and pepper. Cook, stirring constantly to prevent any scorching, until the tomato paste has started to cook in the oil a bit, caramelizing at the edges and going from bright red to a deeper brick red color, about 2 minutes. Remove from heat and transfer about half the mixture to a resealable container, leaving the rest behind. (These are your leftovers to be used elsewhere: in another batch of pasta or smeared onto roasted vegetables, spooned over fried eggs or spread underneath crispy chicken thighs.)",
        "To serve, cook pasta according to package instructions in a large pot of salted boiling water until very al dente (perhaps more al dente than usual). Transfer to Dutch oven with remaining shallot mixture (or a skillet if you are using the leftover portion) and 1 cup pasta water. Cook over medium-high heat, swirling the skillet to coat each piece of pasta, using a wooden spoon or spatula to scrape up any bits on the bottom, until pasta is thick and sauce has reduced and is sticky, but not saucy, 3 to 5 minutes.",
        "In a small bowl, combine parsley and finely chopped garlic clove, and season with flaky salt and pepper. Divide pasta among bowls, or transfer to one large serving bowl, and top with parsley mixture and a bit more red-pepper flakes, if you like."
    ]
)




puts "Done seeding recipes"