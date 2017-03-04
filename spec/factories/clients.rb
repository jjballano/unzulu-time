FactoryGirl.define do
  sequence :name do |n|
    "AnyClient#{n}"
  end

  factory :client do
    name
    association :user, factory: :user
  end
end
