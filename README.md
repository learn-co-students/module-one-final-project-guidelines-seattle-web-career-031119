## NOW that's what I call 90's!

### by Doug Ward and Joe Yang

NOW that's what I call 90's is a Ruby CLI game that challenges the player to guess popular 90's artists based on a line of lyrics from one of their songs.

### Let's Git It

1. Fork the repository
1. In your terminal, clone the repository with `git clone <your fork's link here>`
1. In your terminal, navigate to the project directory
1. Run `bundle install` to download the necessary gems
1. Run `rake db:migrate` to create the proper databases
1. Run `rake run` and get yo 90's on

### Object Model
A Game has many Rounds, and many Players through Rounds
A Player has many Rounds, and many Games through Rounds

![Object Model](https://github.com/wardou2/module-one-final-project-guidelines-seattle-web-career-031119/blob/master/mod_one_proj_model_chart.jpg)

### Sources

https://api.lyrics.ovh/v1/artist/title

https://stackoverflow.com/questions/412169/ruby-how-to-find-item-in-array-which-has-the-most-occurrences
---
