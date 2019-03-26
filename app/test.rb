# curl -X GET --header "Accept: application/json" --header "user-key: 4e444090a6cc15f3ea6a678736291ab3" "https://developers.zomato.com/api/v2.1/cities?q=Seattle%2C%20WA&lat=47.609845&lon=-122.335081&city_ids=279"

# https://developers.zomato.com/api/v2.1/cities?q=Seattle%2C%20WA&lat=47.609845&lon=-122.335081&city_ids=279&count=1


def api_key
  "4e444090a6cc15f3ea6a678736291ab3"
end

def categories
  # gets back the zomato 'meal type' categories - lunch, dinner, delivery, etc.
  response_string = RestClient::Request.execute(method: :get,
                                    url: "https://developers\.zomato\.com/api/v2\.1/categories",
                                headers:
                                  {"user-key": api_key},
                                timeout: 10)
  JSON.parse(response_string)
end

def cities(city)
  # gets back city info from a the string you enter.
  response_string = RestClient::Request.execute(method: :get,
                                    url: "https://developers\.zomato\.com/api/v2\.1/cities?q=#{city}",
                                headers:
                                  {"user-key": api_key},
                                timeout: 10)
  JSON.parse(response_string)
end

def establishments(city_id)
  # gets back the types of establishments in the provided city ID number.
  response_string = RestClient::Request.execute(method: :get,
                                    url: "https://developers.zomato.com/api/v2.1/establishments?city_id=#{city_id}",
                                headers:
                                  {"user-key": api_key},
                                timeout: 10)
  JSON.parse(response_string)
end

def search_city_by_cuisine(entity_id, entity_type="zone", cuisine_id)
  # gets back all types of shit depending on what you enter.
  response_string = RestClient::Request.execute(method: :get,
                                    url: "https://developers\.zomato\.com/api/v2\.1/search?entity_id=#{entity_id}&entity_type=#{entity_type}&cuisines=#{cuisine_id}",
                                headers:
                                  {"user-key": api_key},
                                timeout: 10)
  search_results = JSON.parse(response_string)
  # To return the restaurant names from your search:
  # search_results["restaurants"].map{|rest| puts rest["restaurant"]["name"]}
end

def search_location_for_cuisines(entity_id, entity_type="subzone")
  # gets back all types of shit depending on what you enter.
  response_string = RestClient::Request.execute(method: :get,
                                    url: "https://developers\.zomato\.com/api/v2\.1/search?entity_id=#{entity_id}&entity_type=#{entity_type}&cuisines=#{cuisine_id}",
                                headers:
                                  {"user-key": api_key},
                                timeout: 10)
  search_results = JSON.parse(response_string)
end
