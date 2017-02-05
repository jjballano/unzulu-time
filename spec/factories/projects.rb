FactoryGirl.define do
  factory :project do
    name "MyString"
    association :user, factory: :user
  end
end
