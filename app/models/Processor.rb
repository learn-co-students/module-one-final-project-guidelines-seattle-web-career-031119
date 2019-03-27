class Processor

  def self.display_pretty_location_hash(hash)
    hash.each do |key, value|
      print "#{key}: "
      value.each {|key, value| puts "#{key}\n"}
    end
  end

  def self.location_menu_prep(locations)
    # Filters out non-US locations and returns an array of indexes to the
    # locations from the api_location_suggestions hash
    location_suggestions_hash = []
    locations.each_with_index do |loc, i|
      if loc["country_id"] == 216
        location_suggestions_hash << i
      end
    end
    location_suggestions_hash
  end

  def self.pretty_location_menu(location_suggestions_hash, locations)
    # Takes the suggestions menu index
    loc_menu_hash = Hash.new
    menu_number = 1
    location_suggestions_hash.map do |itemno|
      #puts "#{menu_number}. #{locations[itemno]['title']}"
      loc_menu_hash[menu_number] = {locations[itemno]['title'] => itemno}
      menu_number += 1
    end
    loc_menu_hash
  end

  def self.most_occuring_cuisines(restaurants)
    # Take in a hash of restaurants and make a hash of cuisines (keys) and frequency (values)
    cuis_hash = Hash.new(0)
    restaurants.map do |res|
      cuisine_array = []
      cuisine_array = res["restaurant"]["cuisines"].split(", ")
      cuisine_array.map {|c| cuis_hash[c] += 1 }
    end
    # Sorts hash by values, turning it into an array and back
    cuis_hash = cuis_hash.sort { |l, r| r[1]<=>l[1] }.to_h
    final_hash = Hash.new
    cuis_hash.keys.each.with_index(1) do |key, index|
      final_hash[index] = {key => cuis_hash[key]}
    end
    final_hash
  end

end
