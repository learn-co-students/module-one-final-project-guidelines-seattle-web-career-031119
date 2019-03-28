
#Mealworm

Mealworm is a Ruby application built to help users find, store, and gather information for recipes and meals.

Mealworm utilizes the Spoonacular API (https://spoonacular.com/food-api) to gather recipe information that is then stored and accessed in a database.

Users can search for recipes based on diet and intolerances, store those recipes, get shopping lists, rate and comment on recipes, and get instructions on how to prepare a recipe.


##Features

Mealworm has many features that you can explore.  A basic user flow could be as follows:

  - Create a username to access usage within your database

  - Find a recipe based on name, diets, or food intolerances

  - Save the meal and determine if you want the recipe in your shopping list, if you'd like to cook the recipe, or delete it.

  - Obtain a detailed shopping list of ingredients based on your selected recipes.

  - Cook a recipe and obtain detailed instructions for making each recipe.


##Running Mealworm

1. Please obtain an API key from Spoonacular (https://rapidapi.com/spoonacular/api/recipe-food-nutrition).  This is free, but does require a credit card to be added for any overages that you may incur.  Copy this API key to add into the application.

There is a file in the application called 'sample.api_key.rb'. Duplicate this file.  Change the name of the duplicated file to be 'api_key.rb'.  Make sure the file name is exactly as described because this file, with your API key, will be hidden by git.

Within the 'api_key.rb' file, replace '[YOUR API KEY HERE]' with your copied API key.  This will now allow the application to communicate with Spoonacular.


2. Run 'bundle install' in your terminal to get the necessary gems installed.


##Authors

This project was built by Rylan Bauermeister and Quinn Cox.


##Credits
Thank you to Formatador, Paint, Artii, tty-table, and Pastel for making the application a bit more pretty and efficient.

##Questions/Support
Message either Rylan Bauermeister or Quinn Cox on Github.

##License
MIT © Rylan Bauermeister and Quinn Cox
