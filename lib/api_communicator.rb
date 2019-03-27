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
    {artist: "Boyz II Men", title: "End of the Road"},
    {artist: "Alanis Morissette", title: "Ironic"},
    {artist: "Metallica", title: "Enter Sandman"},
    {artist: "Counting Crows", title: "Mr. Jones"},
    {artist: "Radiohead", title: "Creep"},
    {artist: "Vanilla Ice", title: "Ice Ice Baby"},
    {artist: "TLC", title: "No Scrubs"},
    {artist: "Kris Kross", title: "Jump"},
    {artist: "Green Day", title: "Good Riddance"},
    {artist: "Sir Mix-a-Lot", title: "Baby Got Back"},
    {artist: "Backstreet Boys", title: "I Want It That Way"},
    {artist: "Montell Jordan", title: "This Is How We Do It"},
    {artist: "Ace of Base", title: "The Sign"},
    {artist: "The Cranberries", title: "Linger"},
    {artist: "Christina Aguilera", title: "Genie in a Bottle"},
    {artist: "Smash Mouth", title: "All Star"},
    {artist: "Will Smith", title: "Gettin' Jiggy Wit It"},
    {artist: "Semisonic", title: "Closing Time"},
    {artist: "Sixpence None the Richer", title: "Kiss Me"}
  ]

  def self.add_most_lyric_and_title_to_song_info
    @songs_array.each do |song_info|
      url ="https://api.lyrics.ovh/v1/#{song_info[:artist].gsub(' ', '%20')}/#{song_info[:title].gsub(' ', '%20')}"
      title_exists = Lyric.find_by(song_title: song_info[:title])
      if !title_exists
        lyrics = RestClient.get(url)
        # binding.pry
        lines = JSON.parse(lyrics)["lyrics"].split("\n").reject!(&:empty?)
        freq = lines.inject(Hash.new(0)) {|h,v| h[v] += 1; h}
        song_info[:most_lyric] = lines.max_by {|v| freq[v]}
      end
    end
  end


  def self.find_or_create_lyric(song_info)
    title_exists = Lyric.find_by(song_title: song_info[:title])
    if !title_exists
      Lyric.create(most_lyric: song_info[:most_lyric], artist_name: song_info[:artist], song_title: song_info[:title])
    end
  end

  def self.gather_lyrics
    @songs_array.each do |song_info|
      self.find_or_create_lyric(song_info)
    end
  end

def self.populate_lyrics_table
  self.add_most_lyric_and_title_to_song_info
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
