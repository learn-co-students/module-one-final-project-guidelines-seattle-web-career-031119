class API

  def self.key
    "4e444090a6cc15f3ea6a678736291ab3"
  end

  def self.connect(query_url)
    url_string = "https://developers.zomato.com/api/v2.1/" + query_url
    response_string = RestClient::Request.execute(method: :get,
      url: url_string,
      headers: {"user-key": self.key},
      timeout: 10)
    JSON.parse(response_string)
  end

  def self.location_suggestions(location)
    # Takes the user's location query and returns the API's location suggestions.
    self.connect("locations?query=#{location}&count=10")["location_suggestions"]
  end

  def self.get_restaurants_from_location(location_hash)
    # Once user has selected a location, first get x pages of restaurant results
    # from that city (results), and return as an array of restaurant hashes.
    # We get 20 results per page. Change "number".times to process multiple pages.
    restaurants = []
    1.times do |page|
      results = self.connect("search?entity_id=#{location_hash["entity_id"]}&entity_type=#{location_hash["entity_type"]}&start=#{(page-1)*20}")
      results["restaurants"].map {|rest| restaurants << rest}
    end
    restaurants
  end

end
