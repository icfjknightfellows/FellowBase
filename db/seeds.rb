# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
u = User.new(user_id: SecureRandom.hex(10), name: "Pykih Administrator", email: "admin@pykih.com", role: "admin", password: ENV["PYKIH_ADMIN_PASSWORD"])
u.save(validate: false)

u = User.new(user_id: SecureRandom.hex(10), name: "ICFJ Administrator", email: "knightfellowprojects@gmail.com", role: "admin", password: ENV["ICFJ_ADMIN_PASSWORD"])
u.save(validate: false)