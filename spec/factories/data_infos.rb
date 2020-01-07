FactoryBot.define do
  factory :data_info do
    chart_info { {} }
    min_max { {} }
    data_portion { create(:data_set)}
  end
end
