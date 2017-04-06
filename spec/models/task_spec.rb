require 'rails_helper'

RSpec.describe Task, type: :model do
  
  let!(:task) { create(:task) }
  let(:now) { Time.now }
  ONE_HOUR ||= 3600

  describe 'create' do
    it 'should creates a task period with current time as start' do      

      expect(task.task_periods.size).to eq(1)
      
      expect(task.task_periods[0].started_at).not_to be_nil
    end

    it 'should return started? value depends on if it has any task period started' do
      task.task_periods.first.started_at = Time.now
      expect(task.started?).to be_truthy

      task.task_periods.first.finished_at = Time.now

      task.task_periods.build(started_at: Time.now, finished_at: Time.now)
      expect(task.started?).to be_falsy

      task.task_periods.build(started_at: Time.now, finished_at: nil)
      expect(task.started?).to be_truthy
    end

    it 'should return the start date with the first of its task periods' do
      task.task_periods.first.started_at = now - 10
      task.task_periods.build(started_at: now - 20)
      task.task_periods.build(started_at: now - 5)

      task.save

      expect(task.start_date.to_i).to eq((now - 20).to_i)
    end

    it 'should return the end date with the latest of its task periods' do
      period = task.task_periods.first      
      period.finished_at = now - 10
      period.save      

      task.task_periods.first.finished_at = now - 10
      task.task_periods.build(started_at: now - 50, finished_at: now - 20)
      task.task_periods.build(started_at: now - 10, finished_at: now - 5)

      task.save

      expect(task.finish_date.to_i).to eq((now - 5).to_i)
    end
  end

  describe 'duration' do
    it 'should return the sum of durations for all periods in seconds' do
      task.task_periods.build(started_at: now - 2*ONE_HOUR, finished_at: now - ONE_HOUR)
      task.task_periods.build(started_at: now - ONE_HOUR, finished_at: now - 0.5*ONE_HOUR)

      expect(task.duration.time_in_seconds).to eq(5400)
    end
  end
end
