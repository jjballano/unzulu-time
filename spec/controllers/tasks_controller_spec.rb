require 'rails_helper'

RSpec.describe TasksController, type: :controller do

  let!(:user) { create(:user, username: 'the_user') }
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

  describe 'update' do
    let(:project) { create(:project, user: user) }
    let(:task) { create(:task, project: project) }

    it 'should creates a new task period within the existing task' do
      previous_size = TaskPeriod.where(task: task).count
      post :update, params: {user: 'the_user', id: task.id}, xhr: true

      expect(TaskPeriod.where(task: task).count).to eq(1+previous_size)
      expect(TaskPeriod.where(task: task).last.started?).to be_truthy
    end
  end

  describe 'pause' do
    let(:project) { create(:project, user: user) }
    let(:task) { create(:task, project: project) }

    it 'should add a finished date to the task period already opened' do
      task_period = TaskPeriod.create!(task: task, started_at: Time.now)

      post :pause, params: {user: 'the_user', id: task_period.id}, xhr: true

      expect(TaskPeriod.find(task_period.id).finished_at?).not_to be_nil
      expect(TaskPeriod.find(task_period.id).started?).to be_falsy
    end

    it 'should not allow to finish a task from other user' do
      task_period = TaskPeriod.create!(task: task, started_at: Time.now)

      post :pause, params: {user: 'another_user', id: task_period.id}, xhr: true

      expect(TaskPeriod.find(task_period.id).finished_at).to be_nil
    end
  end

  describe 'stop' do
    let(:project) { create(:project, user: user) }
    let(:task) { create(:task, project: project) }
    let(:task_period) { create(:task_period, task: task) }
    let!(:default_params) { { user: 'the_user', id: task_period.id, task: {billable: true, description: 'hi', project: project.name, client: 'any'} } }

    it 'should add a finished date to the task period already opened' do

      post :stop, params: default_params

      expect(TaskPeriod.find(task_period.id).finished_at?).not_to be_nil
      expect(TaskPeriod.find(task_period.id).started?).to be_falsy
    end

    it 'should not allow to finish a task from other user' do
      task_period = create(:task_period_started)

      post :stop, params: default_params.merge(user: 'another_user')

      task_period.reload
      expect(task_period.finished_at).to be_nil
      expect(response).to redirect_to '/another_user'
    end

    it 'should redirects to index after closing the last task' do
      post :stop, params: default_params

      expect(response).to redirect_to '/the_user'
    end

    it 'should save the task information' do
      default_params[:task] = default_params[:task].merge({description: 'new description', billable: false})
      post :stop, params: default_params

      task.reload
      expect(task.description).to eq('new description')
      expect(task.billable).to be_falsy
    end

    it 'should change the project if it is changed' do
      another_project = create(:project, name: 'another project', user: user)

      default_params[:task] = default_params[:task].merge({project: 'another project'})

      post :stop, params: default_params

      task.reload
      expect(task.project.id).to eq(another_project.id)
    end

    it 'should change the project if it is changed' do
      default_params[:task] = default_params[:task].merge({project: 'new project'})

      post :stop, params: default_params

      task.reload
      expect(task.project.name).to eq('new project')
    end

    it 'should change the client if it is changed when client already exists' do
      another_client = create(:client, name: 'another client', user: user)

      default_params[:task] = default_params[:task].merge({client: 'another client'})

      post :stop, params: default_params

      task.reload

      expect(task.project.client.id).to eq(another_client.id)
    end

    it 'should create the client if it is changed' do
      default_params[:task] = default_params[:task].merge({client: 'new client'})

      post :stop, params: default_params

      task.reload
      
      expect(task.project.client.name).to eq('new client')
    end
  end

end
