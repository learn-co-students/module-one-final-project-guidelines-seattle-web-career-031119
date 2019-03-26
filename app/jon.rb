
def api_key
  "4e444090a6cc15f3ea6a678736291ab3"
end

def locations(city = 'Seattle')
  response_string = RestClient::Request.execute(method: :get,
                                    url: "https://developers.zomato.com/api/v2.1/locations?query=#{city}&lat=47.36&lon=122.20&count=10",
                                headers:
                                  {"user-key": api_key},
                                timeout: 10)

  parsed_string = JSON.parse(response_string)

  parsed_string['location_suggestions'][0]

end
