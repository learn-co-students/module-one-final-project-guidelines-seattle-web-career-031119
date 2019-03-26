# curl -X GET --header "Accept: application/json" --header "user-key: 4e444090a6cc15f3ea6a678736291ab3" "https://developers.zomato.com/api/v2.1/cities?q=Seattle%2C%20WA&lat=47.609845&lon=-122.335081&city_ids=279"

# https://developers.zomato.com/api/v2.1/cities?q=Seattle%2C%20WA&lat=47.609845&lon=-122.335081&city_ids=279&count=1

def api_key
  "4e444090a6cc15f3ea6a678736291ab3"
end

def categories
  response_string = RestClient::Request.execute(method: :get,
                                    url: "https://developers\.zomato\.com/api/v2\.1/categories",
                                headers:
                                  {"user-key": api_key},
                                timeout: 10)
  JSON.parse(response_string)
end

def cities(city)
  response_string = RestClient::Request.execute(method: :get,
                                    url: "https://developers\.zomato\.com/api/v2\.1/cities?q=#{city}",
                                headers:
                                  {"user-key": api_key,
                                   "cities": city},
                                timeout: 10)
  JSON.parse(response_string)
end
