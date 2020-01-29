FactoryBot.define do
  factory :undigested_input do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    keys_info { {} }
    user { create(:user) }
    content {[
      {"cpf": Faker::Number.number(digits: 11), "nome": Faker::Name.name},
      {"cpf": Faker::Number.number(digits: 11), "nome": Faker::Name.name},
      {"cpf": Faker::Number.number(digits: 11), "nome": Faker::Name.name}
    ]}
  end
end
