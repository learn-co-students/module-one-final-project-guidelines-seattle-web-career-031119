require_relative '../config/environment'

Api.populate_lyrics_table
system "clear"
Cli.welcome_message
