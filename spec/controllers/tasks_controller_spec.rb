require 'rails_helper'

RSpec.describe TasksController, type: :controller do

  let!(:user) {create(:user, username: 'the_user')}
  #I have used let! instead of let because let is lazily evaluated

  describe 'index' do
    it 'should creates the user received if it is not already' do      
      expect(User.count).to eq(1)

      get :index, params: { user: 'the_user' }
      expect(User.count).to eq(1)

      get :index, params: { user: 'another_user' }
      expect(User.count).to eq(2)
      expect(User.all[1].username).to eq('another_user')
    end
  end
end
