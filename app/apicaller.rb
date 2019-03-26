class ApiCaller

  def self.get_recipe_by_id(id)
    Unirest.get "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/#{id}/information?includeNutrition=false",
    headers:{
      "X-RapidAPI-Key" => get_api_key
    }
  end

  def self.get_random_recipe_by_search(search)
    response = Unirest.get "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/search?number=100&offset=0&type=main+course&instructionsRequired=true&query=#{search.downcase.split(" ").join("+")}",
  headers:{
    "X-RapidAPI-Key" => get_api_key
  }
    results = response.body["results"]
    get_recipe_by_id(results[rand(0...results.count)]["id"])
  end

end
