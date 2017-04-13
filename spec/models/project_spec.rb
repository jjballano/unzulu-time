require 'rails_helper'

RSpec.describe Project, type: :model do
  
  let(:project) { create(:project) }
  let(:now) { Time.now }

  describe 'time_day' do
    
    it 'should return the time of its tasks in hours:minutes format' do
      task = Task.new
      task.task_periods.build(started_at: now - 1.hour, finished_at: now)
      project.tasks << task
      
      expect(project.time_day.to_s).to eq('01:00')
    end

    it 'should return 00:00 if there is no tasks' do      
      expect(project.time_day.to_s).to eq('00:00')
    end

    it 'should return the time of its task when there is just one' do
      task = Task.new
      task.task_periods.build(started_at: now - 1.5.hour, finished_at: now)
      project.tasks << task
      
      expect(project.time_day.to_s).to eq('01:30')
    end

    it 'should return the time of the sum of all its tasks' do
      task = Task.new
      task.task_periods.build(started_at: now - 1.5.hour, finished_at: now)
      project.tasks << task
      task = Task.new
      task.task_periods.build(started_at: now - 1.hour, finished_at: now)
      project.tasks << task

      expect(project.time_day.to_s).to eq('02:30')
    end

    it 'should not take into account tasks which are not from today' do
      task = Task.new
      task.task_periods.build(started_at: now - 36.hour, finished_at: now - 28.hour)
      project.tasks << task
      
      expect(project.time_day.to_s).to eq('00:00')
    end

  end  

  describe 'time_week' do
    let(:current_week) { Time.now.beginning_of_week(:monday) }
    let(:next_week) { Time.now.end_of_week(:monday) + 1.second }

    it 'should sum all tasks duration for the current week' do
      task = Task.new
      task.task_periods.build(started_at: current_week + 3.hour, finished_at: current_week + 4.hour)
      task.task_periods.build(started_at: current_week + 8.hour, finished_at: current_week + 8.5.hour)
      project.tasks << task

      task = Task.new
      task.task_periods.build(started_at: current_week + 12.hour, finished_at: current_week + 14.hour)
      project.tasks << task

      expect(project.time_week.to_s).to eq('03:30')      
    end

    it 'should not take into account tasks which are not starting this week' do
      task = Task.new
      task.task_periods.build(started_at: current_week - 3.hour, finished_at: current_week - 2.hour)
      project.tasks << task

      task = Task.new
      task.task_periods.build(started_at: next_week + 3.hour, finished_at: next_week + 4.hour)
      project.tasks << task

      task = Task.new
      task.task_periods.build(started_at: current_week - 1.hour, finished_at: current_week + 2.hour)
      project.tasks << task

      task = Task.new
      task.task_periods.build(started_at: next_week - 1.hour, finished_at: next_week + 1.hour)
      project.tasks << task

      expect(project.time_week.to_s).to eq('02:00')
    end

    it 'should take into account tasks started at the very beginning of the week' do
      task = Task.new
      task.task_periods.build(started_at: current_week, finished_at: current_week + 1.hour)
      project.tasks << task

      expect(project.time_week.to_s).to eq('01:00')
    end

    it 'should take into account tasks started at the very end of the week' do
      task = Task.new
      task.task_periods.build(started_at: next_week - 1.second, finished_at: next_week + 1.hour - 1.second)
      project.tasks << task

      expect(project.time_week.to_s).to eq('01:00')
    end

    it 'should not take into account tasks started at the very beginning of the next week' do
      task = Task.new
      task.task_periods.build(started_at: next_week, finished_at: next_week + 1.hour)
      project.tasks << task

      expect(project.time_week.to_s).to eq('00:00')
    end
  end


  describe 'time_month' do
    let(:current_month) { Time.now.beginning_of_month }
    let(:next_month) { Time.now.end_of_month + 1.second }

    it 'should sum all tasks duration for the current month' do
      task = Task.new
      task.task_periods.build(started_at: current_month + 3.hour, finished_at: current_month + 4.hour)
      task.task_periods.build(started_at: current_month + 8.hour, finished_at: current_month + 8.5.hour)
      project.tasks << task

      task = Task.new
      task.task_periods.build(started_at: current_month + 12.hour, finished_at: current_month + 14.hour)
      project.tasks << task

      expect(project.time_month.to_s).to eq('03:30')      
    end

    it 'should not take into account tasks which are not starting this month' do
      task = Task.new
      task.task_periods.build(started_at: current_month - 3.hour, finished_at: current_month - 2.hour)
      project.tasks << task

      task = Task.new
      task.task_periods.build(started_at: next_month + 3.hour, finished_at: next_month + 4.hour)
      project.tasks << task

      task = Task.new
      task.task_periods.build(started_at: current_month - 1.hour, finished_at: current_month + 2.hour)
      project.tasks << task

      task = Task.new
      task.task_periods.build(started_at: next_month - 1.hour, finished_at: next_month + 1.hour)
      project.tasks << task

      expect(project.time_month.to_s).to eq('02:00')
    end

    it 'should take into account tasks started at the very beginning of the month' do
      task = Task.new
      task.task_periods.build(started_at: current_month, finished_at: current_month + 1.hour)
      project.tasks << task

      expect(project.time_month.to_s).to eq('01:00')
    end

    it 'should take into account tasks started at the very end of the month' do
      task = Task.new
      task.task_periods.build(started_at: next_month - 1.second, finished_at: next_month + 1.hour - 1.second)
      project.tasks << task

      expect(project.time_month.to_s).to eq('01:00')
    end

    it 'should not take into account tasks started at the very beginning of the next month' do
      task = Task.new
      task.task_periods.build(started_at: next_month, finished_at: next_month + 1.hour)
      project.tasks << task

      expect(project.time_month.to_s).to eq('00:00')
    end
  end

  describe 'time_total' do
    it 'should return the total of time spent in the project no matter when the tasks were done' do
      task = Task.new
      task.task_periods.build(started_at: now - 3.month, finished_at: now - 3.month + 1.hour)
      project.tasks << task

      task = Task.new
      task.task_periods.build(started_at: now + 3.month, finished_at: now + 3.month + 1.hour)
      project.tasks << task

      task = Task.new
      task.task_periods.build(started_at: now - 2.hours, finished_at: now)
      project.tasks << task

      expect(project.time_total.to_s).to eq('04:00')
    end
  end
end
