FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birthdate { Faker::Date.birthday(min_age: 18, max_age: 65) }
    email { Faker::Internet.email }
    role { "One independent role" }
    password { "123456" }
    password_confirmation { "123456" }
  end
end
