require 'rails_helper'

RSpec.describe TaskPeriod, type: :model do

  it 'should return started? value depending on finished date' do
    task_period = TaskPeriod.new

    task_period.finished_at = nil
    expect(task_period.started?).to be_truthy

    task_period.finished_at = Time.now
    expect(task_period.started?).to be_falsy

  end

end
