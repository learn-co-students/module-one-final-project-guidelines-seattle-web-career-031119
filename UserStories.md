Zomato
DATA ANALYTICS PROJECT

classes:

#User
-(UserPrefs)

-Restaurant

-Review

-Cuisine

-MealType

-Location

-Menu

#User Stories


Start the app

Welcome

1. Starting options:
  a. Start new user
    Get name
  b. Get list of saved users
    List names and prompt to enter yours

2. Choice:
  a. See own reviews
  b. Search for restaurant

B1. Input location
      By city
      By Neighborhood
    Matches text input to location
    Returns list of cuisines

B2. Input cuisine by name

B3. Get back list of restaurants, sorted by review average DESC

B4. Choose:
  a. Review restaurant from B3 list
    Choose by number
    Enter a rating 1-5
    Enter message
    Review.new
    Choice:
      1. New review from B3 list
      2. Back to step 2
  b. New search
    go to B1




  Find restaurants

  Enter location
  Enter distance
  Enter cuisine

  Return list of restaurants sorted by reviews DESC



As a user, I want to find restaurants I'm interested in.

a. enter location
b. enter cuisine
c. return a list of restaurants that match the above, sorted by review average.
d. ability to add restaurant from search to your list.

USEFUL TEST DATA:
Seattle: 279
NYC: 280
Marta (italian resto in NYC): 16793301
Seattle Fremont Neighborhood Subzone: 113167

BONUSES

Get densest restaurant district within x miles

Find the restaurant that has updated its menu most recently.
