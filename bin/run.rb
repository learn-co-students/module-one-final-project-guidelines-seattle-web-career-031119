require_relative '../config/environment'

Api.populate_lyrics_table

Cli.welcome_message
Cli.get_username
Cli.start_a_game

puts "HELLO WORLD"
