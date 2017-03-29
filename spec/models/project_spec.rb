require 'rails_helper'

RSpec.describe Project, type: :model do
  
  let(:project) { create(:project) }

  describe 'time_day' do

    ONE_AND_HALF_HOURS = 5400
    let(:now) { Time.now }

    it 'should return the the time of its tasks in hours:minutes format' do
      task = Task.new
      task.task_periods << TaskPeriod.new(started_at: now - ONE_AND_HALF_HOURS, finished_at: now)
      project.tasks << task
      
      expect(project.time_day).to eq('1:30')
    end
  end  
end
