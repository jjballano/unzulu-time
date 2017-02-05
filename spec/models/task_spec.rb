require 'rails_helper'

RSpec.describe Task, type: :model do
  
  let!(:task) { build(:task) }

  describe 'create' do
    it 'should creates a task period with current time as start' do      

      task.save

      expect(task.task_periods.size).to eq(1)
      
      expect(task.task_periods[0].started_at).not_to be_nil
    end

    it 'should return started? value depends on if it has any task period started' do
      expect(task.started?).to be_falsy

      task.task_periods.build(started_at: Time.now, finished_at: Time.now)
      expect(task.started?).to be_falsy

      task.task_periods.build(started_at: Time.now, finished_at: nil)
      expect(task.started?).to be_truthy
    end
  end
end
