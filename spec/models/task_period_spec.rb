require 'rails_helper'

RSpec.describe TaskPeriod, type: :model do
  let(:now) { Time.now }
  let(:task_period) { create(:task_period) } 
  ONE_HOUR ||= 3600

  it 'should return started? value depending on finished date' do

    task_period.finished_at = nil
    expect(task_period.started?).to be_truthy

    task_period.finished_at = Time.now
    expect(task_period.started?).to be_falsy

  end

  describe 'duration' do
    it 'should return the duration of the task in seconds' do
      task_period.started_at = now - ONE_HOUR
      task_period.finished_at = now - 0.5*ONE_HOUR

      expect(task_period.duration).to eq(1800)
    end
  end

  describe 'close' do
    it 'should set the finished_at attribute to the current time' do
      task_period = create(:task_period_started)

      task_period.close

      task_period.reload

      expect(task_period.finished_at).not_to be_nil

    end
  end

end
