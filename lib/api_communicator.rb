require_relative '../config/environment.rb'

songs_array = [
    {artist: "Thriller", title: "Michael Jackson"},
    {artist: "Hello", title: "Adele"}
]

urls = songs_array.collect do |song_info|
  "https://api.lyrics.ovh/v1/#{song_info[:artist].gsub(' ', '%20')}/#{song_info[:title].gsub(' ', '%20')}"
end

binding.pry
0
