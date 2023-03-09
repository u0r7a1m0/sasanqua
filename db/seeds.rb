# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admins = [
 {email: 'nagano@cake', password: 'bookers'},
]
admins.each do |admin|
 admin_data = Admin.find_by(email: admin[:email])
 if admin_data.nil?
  Admin.create(email: admin[:email], password: admin[:password])
 end
end

customers = [
 {email: 'ai@com', password: 'bookers', nickname: "愛"},
 {email: 'naho@com', password: 'bookers', nickname: "なほ"},
 {email: 'momo@com', password: 'bookers', nickname: "momo"},
 {email: 'kei@com', password: 'bookers', nickname: "Kay"},
 {email: 'sou@com', password: 'bookers', nickname: "ソウ"},
]
customers.each do |customer|
 customer_data = Customer.find_by(email: customer[:email])
 if customer_data.nil?
  Customer.create(email: customer[:email], password: customer[:password], nickname: customer[:nickname])
 end
end
