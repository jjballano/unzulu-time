require 'rails_helper'

RSpec.describe Project, type: :model do
  
  let(:project) { create(:project) }

  describe 'time_day' do

    ONE_HOUR = 3600
    let(:now) { Time.now }

    it 'should return the time of its tasks in hours:minutes format' do
      task = Task.new
      task.task_periods << TaskPeriod.new(started_at: now - ONE_HOUR, finished_at: now)
      project.tasks << task
      
      expect(project.time_day).to eq('01:00')
    end

    it 'should return 00:00 if there is no tasks' do      
      expect(project.time_day).to eq('00:00')
    end

    it 'should return the time of its task when there is just one' do
      task = Task.new
      task.task_periods << TaskPeriod.new(started_at: now - 1.5*ONE_HOUR, finished_at: now)
      project.tasks << task
      
      expect(project.time_day).to eq('01:30')
    end

    it 'should return the time of the sum of all its tasks' do
      task = Task.new
      task.task_periods << TaskPeriod.new(started_at: now - 1.5*ONE_HOUR, finished_at: now)
      project.tasks << task
      task = Task.new
      task.task_periods << TaskPeriod.new(started_at: now - 1*ONE_HOUR, finished_at: now)
      project.tasks << task

      expect(project.time_day).to eq('02:30')
    end

    it 'should not take into account tasks which are not from today' do
      task = Task.new
      task.task_periods << TaskPeriod.new(started_at: now - 36*ONE_HOUR, finished_at: now - 28*ONE_HOUR)
      project.tasks << task
      
      expect(project.time_day).to eq('00:00')
    end

  end  
end
