class Round < ActiveRecord::Base
  belongs_to :games
  belongs_to :players
end


# # --------------put this code somewhere--------------------
# def get_lyric
#   lyrics = RestClient.get(self)
#   lines = JSON.parse(lyrics)["lyrics"].split("\n").reject!(&:empty?)
#   freq = lines.inject(Hash.new(0)) {|h,v| h[v] += 1; h}
#   lines.max_by {|v| freq[v]}
# end
#
#
# def lyric_getter(artist, title)
#   "https://api.lyrics.ovh/v1/#{artist.gsub(' ','%20')}/#{title.gsub(' ','%20')}".get_lyric
# end
