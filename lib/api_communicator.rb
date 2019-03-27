require_relative '../config/environment.rb'


class Api

  @songs_array = [
    {artist: "Nirvana", title: "Smells Like Teen Spirit"},
    {artist: "Britney Spears", title: "...Baby One More Time"},
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

  def self.add_most_lyric_to_song_info
    @songs_array.each do |song_info|
      url ="https://api.lyrics.ovh/v1/#{song_info[:artist].gsub(' ', '%20')}/#{song_info[:title].gsub(' ', '%20')}"
      lyrics = RestClient.get(url)
      lines = JSON.parse(lyrics)["lyrics"].split("\n").reject!(&:empty?)
      freq = lines.inject(Hash.new(0)) {|h,v| h[v] += 1; h}
      song_info[:most_lyric] = lines.max_by {|v| freq[v]}
    end
  end


  def self.find_or_create_lyric(song_info)
    lyric_exists = Lyric.find_by(most_lyric: song_info[:most_lyric])
    if !lyric_exists
      Lyric.create(most_lyric: song_info[:most_lyric], artist_name: song_info[:artist])
    end
  end

  def self.gather_lyrics
    @songs_array.each do |song_info|
      self.find_or_create_lyric(song_info)
    end
  end

def self.populate_lyrics_table
  self.add_most_lyric_to_song_info
  self.gather_lyrics
end

# binding.pry


end

#=============Random 90s Phrases==============

# Correct:
# ["You are all that and a bag of chips!", "Boo ya!", "You da bomb!", "Great job home skillet!", "Nice, dude!", "Slammin!"]
#
# Incorrect:
# ["As if!", "Oh snap!", "Talk to the hand!", "That's right! ...NOT!", "You were hella close...", "Whatever!"]








# binding.pry
0
