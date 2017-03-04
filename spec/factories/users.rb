
FactoryGirl.define do
  sequence :username do |n|
    "AnyUser#{n}"
  end

  factory :user do
    username 
    registered false
  end
end
