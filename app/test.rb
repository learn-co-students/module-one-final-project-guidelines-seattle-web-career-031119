# curl -X GET --header "Accept: application/json" --header "user-key: 4e444090a6cc15f3ea6a678736291ab3" "https://developers.zomato.com/api/v2.1/cities?q=Seattle%2C%20WA&lat=47.609845&lon=-122.335081&city_ids=279"

# https://developers.zomato.com/api/v2.1/cities?q=Seattle%2C%20WA&lat=47.609845&lon=-122.335081&city_ids=279&count=1

def api_key
  "4e444090a6cc15f3ea6a678736291ab3"
end

def match_input_to_location(location)
  response_string = RestClient::Request.execute(method: :get,
                                    url: "https://developers.zomato.com/api/v2.1/locations?query=#{location}&count=10",
                                headers:
                                  {"user-key": api_key},
                                timeout: 10)
  JSON.parse(response_string)["location_suggestions"]
end

def location_suggestions(locations)
  suggestions_menu = []
  locations.each_with_index do |loc, i|
    if loc["country_id"] == 216
      suggestions_menu << i
    end
  end
  suggestions_menu
end

def pretty_location_menu(suggestions_menu, locations)
  loc_menu_output = Hash.new
    menu_number = 1
  suggestions_menu.map do |itemno|
    puts "#{menu_number}. #{locations[itemno]['title']}"
    loc_menu_output[menu_number] = locations[itemno]['title']
    menu_number += 1
  end
  loc_menu_output
end

def search_area_for_cuisines(entity_id, entity_type)
  # City search for cuisines
  restaurants = []
  # gets multiple pages of results and stores in restaurants
  1.times do |page|
    response_string = RestClient::Request.execute(method: :get,
                                      url: "https://developers\.zomato\.com/api/v2\.1/search?entity_id=#{entity_id}&entity_type=#{entity_type}&start=#{(page-1)*20}",
                                  headers:
                                    {"user-key": api_key},
                                  timeout: 10)
    results = JSON.parse(response_string)
    results["restaurants"].map {|rest| restaurants << rest}
  end
  restaurants
end

def cuisines(restaurants)
  # Take in a hash of restaurants and make a hash of cuisines (keys) and frequency (values)
  cuis_hash = Hash.new(0)
  restaurants.map do |res|
    cuisine_array = []
    cuisine_array = res["restaurant"]["cuisines"].split(", ")
    cuisine_array.map {|c| cuis_hash[c] += 1 }
  end
  # Sorts hash by values, turning it into an array and back
  cuis_hash.sort { |l, r| r[1]<=>l[1] }.to_h
end


# OLD METHODS GRAVEYARD
#
# def categories
#   # gets back the zomato 'meal type' categories - lunch, dinner, delivery, etc.
#   response_string = RestClient::Request.execute(method: :get,
#                                     url: "https://developers\.zomato\.com/api/v2\.1/categories",
#                                 headers:
#                                   {"user-key": api_key},
#                                 timeout: 10)
#   JSON.parse(response_string)
# end

# def cities(city)
#   # gets back city info from a the string you enter.
#   response_string = RestClient::Request.execute(method: :get,
#                                     url: "https://developers\.zomato\.com/api/v2\.1/cities?q=#{city}",
#                                 headers:
#                                   {"user-key": api_key},
#                                 timeout: 10)
#   JSON.parse(response_string)
# end

# def establishments(city_id)
#   # gets back the types of establishments in the provided city ID number.
#   response_string = RestClient::Request.execute(method: :get,
#                                     url: "https://developers.zomato.com/api/v2.1/establishments?city_id=#{city_id}",
#                                 headers:
#                                   {"user-key": api_key},
#                                 timeout: 10)
#   JSON.parse(response_string)
# end
