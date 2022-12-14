# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create an Admin user
User.create!(
    email: 'admin@test.com',
    password: 'admin123',
    confirmed_at: DateTime.current,
    admin: true
)

User.create!(
    email: 'admin2@test.com',
    password: 'admin123',
    confirmed_at: DateTime.current,
    admin: true
)

User.create!(
    email: 'testx@test.com',
    password: 'test123',
    confirmed_at: DateTime.current,
    admin: false
)

User.create!(
    email: 'testy@test.com',
    password: 'test123',
    confirmed_at: DateTime.current,
    admin: false
)