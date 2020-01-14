# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
User.create(first_name: "Marie",
            last_name: "Curie",
            birthdate: Time.strptime("07/11/1867,", "%d/%m/%Y"),
            role: "Computer Scientist",
            permission: "admin", 
            email: "marie.curie@great.women.com",
            password: "Marie Curie",
            password_confirmation: "Marie Curie")

User.create(first_name: "Margaret",
            last_name: "hamilton",
            birthdate: Time.strptime("17/08/1936", "%d/%m/%Y"),
            role: "Computer Scientist",
            permission: "standard",
            email: "margaret.hamilton@great.women.com",
            password: "Margaret Hamilton",
            password_confirmation: "Margaret Hamilton")


3.times do
  DataSet.create(name: Faker::Name.name,
                description: Faker::Lorem.paragraph,
                keys_info: {})
end
