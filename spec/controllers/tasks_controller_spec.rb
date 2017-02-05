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

    describe 'returns all projects' do
      it 'when user already exists' do
        user.projects.create(name: 'any project')
        user.projects.create(name: 'another project')

        expect(Project.count).to eq(2)

        get :index, params: { user: 'the_user' }

        expect(assigns(:user).projects.map(&:name)).to eq(['any project', 'another project'])
      end

      it 'when user does not exist' do
        get :index, params: { user: 'new_user' }

        expect(assigns(:user).projects).to be_empty
      end
    end

    it 'should assigns to the task the last project used' do
      user.projects.create!(name: 'any project')
      user.projects.create!(name: 'another project')
      user.projects.create!(name: 'last project')
      user.projects[0].tasks.create!(description: 'any description')
      user.projects[1].tasks.create!(description: 'another description')
      expect(Task.count).to eq(2)

      get :index, params: { user: 'the_user' }

      expect(assigns(:task).project.name).to eq('another project')
    end
  end

  describe 'create' do
    it 'should creates the project if it doesnt exist yet' do
      post :create, params: { project: 'any project', user: 'the_user' }, xhr: true
      
      expect(Project.where(user: user).count).to eq(1)
    end

    it 'should not creates the project if it already exists' do
      project = Project.create(user: user, name: 'any project')

      post :create, params: { project: 'any project', user: 'the_user' }, xhr: true
      
      expect(Project.where(user: user).count).to eq(1)
      expect(Project.where(user: user).first).to eq(project)
    end

    it 'should creates a task' do
      post :create, params: { project: 'any project', user: 'the_user' }, xhr: true

      project = Project.where(name: 'any project', user: user).first

      expect(Task.where(project: project).count).to eq(1)
      expect(assigns(:task)).not_to be_nil
      expect(assigns(:task_period).started_at).not_to be_nil
      expect(assigns(:task_period).started?).to be_truthy
    end
  end

end
