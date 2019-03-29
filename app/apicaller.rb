class ApiCaller

  def self.get_recipe_by_id(id)
    Unirest.get "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/#{id}/information?includeNutrition=false",
    headers:{
      "X-RapidAPI-Key" => get_api_key
    }
  end

  def self.get_random_recipe_by_search(search, diet_intolerance_syntax, user)

    if diet_intolerance_syntax == ""
      response = Unirest.get "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/search?number=100&offset=0&instructionsRequired=true&query=#{search.downcase.split(" ").join("+")}",
    headers:{
      "X-RapidAPI-Key" => get_api_key
    }
    else
        response = Unirest.get "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/search?#{diet_intolerance_syntax}&number=100&offset=0&instructionsRequired=true&query=#{search.downcase.split(" ").join("+")}",
      headers:{
        "X-RapidAPI-Key" => get_api_key
      }

    end
    results = response.body["results"]
    get_recipe_by_cache_or_query(user, results)
  end

  def self.get_recipe_by_cache_or_query(user, results)
    user.recipes.each do |existing_recipe|
      results.delete_if{|incoming_recipe|
        incoming_recipe["id"] == existing_recipe.external_id
      }
    end

    if results.count > 0
      target_index = rand(0...results.count)
      if Recipe.all.any? {|recipe| recipe.external_id == results[target_index]["id"]}
        Recipe.find_by(external_id: results[target_index]["id"])
      else
        get_recipe_by_id(results[target_index]["id"]).body
      end
    else
      nil
    end
  end
end
