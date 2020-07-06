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
