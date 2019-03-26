
def api_key
  "4e444090a6cc15f3ea6a678736291ab3"
end

def cuisine(city_id)
  response_string = RestClient::Request.execute(method: :get,
                                    url: "https://developers.zomato.com/api/v2.1/cuisines?city_id=#{city_id}",
                                headers:
                                  {"user-key": api_key},
                                timeout: 10)
  parsed_response = JSON.parse(response_string)
  cuisine_hash = {}
  parsed_response["cuisines"].each {|cuisine|
    cuisine.each {|key, value|
      cuisine_hash[value["cuisine_name"]] = value["cuisine_id"]
    }
  }
  cuisine_hash
end

def establishment(city_id)
  response_string = RestClient::Request.execute(method: :get,
                                    url: "https://developers.zomato.com/api/v2.1/establishments?city_id=#{city_id}",
                                headers:
                                  {"user-key": api_key},
                                timeout: 10)
  parsed_response = JSON.parse(response_string)
  establishment_ids = []
  parsed_response["establishments"].each {|establishment|
    establishment.each {|key, value|
      establishment_ids << value["id"]
    }
  }
  establishment_ids
end
