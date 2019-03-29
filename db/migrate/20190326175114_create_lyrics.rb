class CreateLyrics < ActiveRecord::Migration[5.0]
  def change
    create_table :lyrics do |t|
      t.string :artist_name
      t.string :most_lyric
      t.string :song_title
    end
  end
end
