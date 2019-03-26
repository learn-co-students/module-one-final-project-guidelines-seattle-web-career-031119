require_relative '../config/environment.rb'

def get_lyric(url)
  lyrics = RestClient.get(url)
  lines = JSON.parse(lyrics)["lyrics"].split("\n").reject!(&:empty?)
  freq = lines.inject(Hash.new(0)) {|h,v| h[v] += 1; h}
  lines.max_by {|v| freq[v]}
end

songs_array = [
    {artist: "Nirvana", title: "Smells Like Teen Spirit"},
    {artist: "Britney Spears", title: "Baby One More Time"},
    {artist: "Sinead O'Connor", title: "Nothing Compares 2 U"},
    {artist: "Blackstreet", title: "No Diggity"},
    {artist: "No Doubt", title: "Dont Speak"},
    {artist: "Spice Girls", title: "Wannabe"},
    {artist: "The Verve", title: "Bitter Sweet Symphony"},
    {artist: "Beck", title: "Loser"},
    {artist: "Ricky Martin", title: "Livin La Vida Loca"},
    {artist: "REM", title: "Losing My Religion"},
    {artist: "Oasis", title: "Wonderwall"},
    {artist: "Boyz II Men", title: "End of the Road"}
]

songs_array.each do |song_info|
  song_info[:url]="https://api.lyrics.ovh/v1/#{song_info[:artist].gsub(' ', '%20')}/#{song_info[:title].gsub(' ', '%20')}"
end

binding.pry

# urls.collect do |url|
#   url.get_lyric
# end



# def lyric_getter(artist, title)
#   "https://api.lyrics.ovh/v1/#{artist.gsub(' ','%20')}/#{title.gsub(' ','%20')}".get_lyric
# end


# binding.pry
0
