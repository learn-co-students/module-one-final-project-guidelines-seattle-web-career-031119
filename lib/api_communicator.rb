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
    {artist: "Sixpence None the Richer", title: "Kiss Me"},
    {artist: "House of Pain", title: "Jump Around"},
    {artist: "Seal", title: "Kiss From a Rose"},
    {artist: "Bell Biv Devoe", title: "Poison"},
    {artist: "Pearl Jam", title: "Jeremy"},
    {artist: "Red Hot Chili Peppers", title: "Under the Bridge"},
    {artist: "Hanson", title: "MMMBop"},
    {artist: "Soundgarden", title: "Black Hole Sun"},
    {artist: "Third Eye Blind", title: "Semi-Charmed Life"},
    {artist: "Spin Doctors", title: "Two Princes"},
    {artist: "Hootie & the Blowfish", title: "Only Wanna Be With You"},
    {artist: "2Pac", title: "California Love"},
    {artist: "Sheryl Crow", title: "All I Wanna Do"},
    {artist: "Right Said Fred", title: "I'm Too Sexy"},
    {artist: "Blues Traveler", title: "Run-around"},
    {artist: "All 4 One", title: "I Swear"}
  ]

  def self.add_most_lyric_and_title_to_song_info
    progressbar = ProgressBar.create(:title => "Loading Game", :starting_at => Lyric.count, :total => @songs_array.count)
    @songs_array.each do |song_info|
      url ="https://api.lyrics.ovh/v1/#{song_info[:artist].gsub(' ', '%20')}/#{song_info[:title].gsub(' ', '%20')}"
      title_exists = Lyric.find_by(song_title: song_info[:title])
      if !title_exists
        lyrics = RestClient.get(url)
        lines = JSON.parse(lyrics)["lyrics"].split("\n").reject!(&:empty?)
        freq = lines.inject(Hash.new(0)) {|h,v| h[v] += 1; h}
        song_info[:most_lyric] = lines.max_by {|v| freq[v]}
        1.times {progressbar.increment}
      end
    end
    system "clear"
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

end
