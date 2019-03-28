class ApiCaller

  def self.get_recipe_by_id(id)
    Unirest.get "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/#{id}/information?includeNutrition=false",
    headers:{
      "X-RapidAPI-Key" => get_api_key
    }
  end

  def self.get_random_recipe_by_search(search, diet)
    if diet == "none"
      response = Unirest.get "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/search?number=100&offset=0&instructionsRequired=true&query=#{search.downcase.split(" ").join("+")}",
    headers:{
      "X-RapidAPI-Key" => get_api_key
    }
      results = response.body["results"]
      if results.count > 0
        get_recipe_by_id(results[rand(0...results.count)]["id"])
      else
        nil
      end
    else
        response = Unirest.get "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/search?diet=#{diet.downcase}&number=100&offset=0&instructionsRequired=true&query=#{search.downcase.split(" ").join("+")}",
      headers:{
        "X-RapidAPI-Key" => get_api_key
      }
        results = response.body["results"]
        if results.count > 0
          get_recipe_by_id(results[rand(0...results.count)]["id"])
        else
          nil
        end
      end
  end

end
