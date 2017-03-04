FactoryGirl.define do
  factory :task_period do
    started_at  "2017-02-05 17:20:00"
    finished_at "2017-02-05 17:42:59"
    association :task, factory: :task    
  end

  factory :task_period_started, class: TaskPeriod, parent: :task_period do
    finished_at nil
  end
end
