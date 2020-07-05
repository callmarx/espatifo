FactoryBot.define do
  factory :data_set do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    keys_info { {} }
  end
end
