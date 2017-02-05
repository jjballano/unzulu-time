FactoryGirl.define do
  factory :task do
    description "MyText"
    association :project, factory: :project
  end
end
