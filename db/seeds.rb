# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create an Admin user
User.create!(
    email: 'admin1@test.com',
    password: 'admin123',
    confirmed_at: '2022-11-14 08:07:42.469777',
    admin: true
)

User.create!(
    email: 'test6@test.com',
    password: 'test123',
    confirmed_at: '2022-11-14 08:07:42.469777',
    admin: false
)

User.create!(
    email: 'test7@test.com',
    password: 'test123',
    confirmed_at: '2022-11-14 08:07:42.469777',
    admin: false
)