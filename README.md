## NOW that's what I call 90's!

#### by Doug Ward and Joe Yang

"NOW that's what I call 90's" is a Ruby CLI game that challenges the player to guess the 90's artist based on a line of lyrics from one of their most popular songs. The first time the game is run, it will take approximately 40 seconds to populate the database, but every subsequent running should load instantly, unless there are new songs added. It will take about 1 second to load each additional song.

For optimal gameplay, your terminal window size should be at least 70 x 40. 

### Let's Git It

1. Fork the repository
2. In your terminal, clone the repository by typing
```
git clone wardou2/module-one-final-project-now-thats-what-i-call-90s
```
3. In your terminal, navigate to the project directory
4. Run `bundle install` to download the necessary gems
5. Run `rake db:migrate` to create the proper tables
6. Run `rake run` to get yo 90's on!

### Object Model
A Game has many Rounds, and many Players through Rounds

A Player has many Rounds, and many Games through Rounds

![Object Model](https://github.com/wardou2/module-one-final-project-guidelines-seattle-web-career-031119/blob/master/mod_one_proj_model_chart.jpg)

### Sources

We used the [Lyrics.ovh API](https://api.lyrics.ovh/v1/artist/title) to gather the lyrics to populate our database.

### Credits

[Method to get most common line from song](https://stackoverflow.com/questions/412169/ruby-how-to-find-item-in-array-which-has-the-most-occurrences)

Gems used: [Paint](https://github.com/janlelis/paint), [Terminal Table](https://github.com/tj/terminal-table), [Ruby Progressbar](https://github.com/jfelchner/ruby-progressbar)

Shoutout to Rylan for "System clear"


---
