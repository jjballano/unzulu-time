FactoryGirl.define do
  factory :project do
    name "MyString"
    association :user, factory: :user
    association :client, factory: :client
  end
end
