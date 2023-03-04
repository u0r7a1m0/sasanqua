# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create!(
  email: 'nagano@cake',
  password: 'bookers',
)
Customer.create!(
 email: "ai@com",
 password: "bookers",
 nickname: "愛",
)
Customer.create!(
 email: "naho@com",
 password: "bookers",
 nickname: "なほ",
)
Customer.create!(
 email: "momo@com",
 password: "bookers",
 nickname: "momo",
)
Customer.create!(
 email: "kei@com",
 password: "bookers",
 nickname: "Kay",
)
Customer.create!(
 email: "sou@com",
 password: "bookers",
 nickname: "ソウ",
)