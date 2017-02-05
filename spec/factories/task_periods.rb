FactoryGirl.define do
  factory :task_period do
    started_at  "2017-02-05 17:20:00"
    finished_at "2017-02-05 17:42:59"
    association :task, factory: :task    
  end
end
