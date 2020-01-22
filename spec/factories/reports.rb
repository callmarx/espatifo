FactoryBot.define do
  factory :report do
    name { "MyString" }
    description { "MyText" }
    config_body { {} }
    user { create(:user) }
    data_set { create(:data_set)}
  end
end
