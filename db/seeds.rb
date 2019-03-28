
abe = User.create(name: "abe")
jon = User.create(name: "jon")
mera = User.create(name: "mera")

pizza = Restaurant.create(name: "The pizza place")
gyros = Restaurant.create(name: "The gyros place")
pasta = Restaurant.create(name: "The pasta place")
sandwich = Restaurant.create(name: "The sandwich place")

r1 = Review.create(user: mera, restaurant: sandwich, rating: 4, message: "Great food.")
r3 = Review.create(user: mera, restaurant: sandwich, rating: 4, message: "Great food.")
r1 = Review.create(user: mera, restaurant: sandwich, rating: 4, message: "Great food.")
r3 = Review.create(user: mera, restaurant: sandwich, rating: 4, message: "Great food.")
r1 = Review.create(user: mera, restaurant: sandwich, rating: 4, message: "Great food.")
r3 = Review.create(user: mera, restaurant: sandwich, rating: 4, message: "Great food.")
r6 = Review.create(user: mera, restaurant: sandwich, rating: 4, message: "Great food.")
r2 = Review.create(user: mera, restaurant: gyros, rating: 1, message: "bad food.")
r4 = Review.create(user: jon, restaurant: pasta, rating: 3, message: "sometimes good food.")
