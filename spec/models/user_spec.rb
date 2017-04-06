require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { build(:user) }

  it "should be valid" do    
    expect(user).to be_valid
  end

  it "should require username" do    
    user.username = nil
    expect(user).to_not be_valid
  end

  it "should not allow creating duplicate usernames" do
    build(:user, username: 'test1').save

    new_user = build(:user, username: 'test1')    
    new_user.save

    expect(new_user).to_not be_valid
  end

  it "should has registered sets to false by default" do
    user = User.new(username: 'any')
    expect(user).to be_valid

    user.save
    expect(user.registered).to be_falsy
  end

  describe "total_day" do
    it "should return the time of the tasks' project" do
      project = Project.new
      allow(project).to receive(:time_day) { Duration.new(180) }
      user.projects << project

      expect(user.total_day.to_s).to eq("00:03")
    end

    it "should return the sum of time of the tasks of all projects" do
      project = Project.new
      allow(project).to receive(:time_day) { Duration.new(180) }
      user.projects << project
      project2 = Project.new
      allow(project2).to receive(:time_day) { Duration.new(120) }
      user.projects << project2

      expect(user.total_day.to_s).to eq("00:05")
    end

  end

  describe "total_week" do
    it "should return the time of the tasks' project" do
      project = Project.new
      allow(project).to receive(:time_week) { Duration.new(180) }
      user.projects << project

      expect(user.total_week.to_s).to eq("00:03")
    end

    it "should return the sum of time of the tasks of all projects" do
      project = Project.new
      allow(project).to receive(:time_week) { Duration.new(1800) }
      user.projects << project
      project2 = Project.new
      allow(project2).to receive(:time_week) { Duration.new(1200) }
      user.projects << project2

      expect(user.total_week.to_s).to eq("00:50")
    end
  end

  describe "total_month" do
    it "should return the time of the tasks' project" do
      project = Project.new
      allow(project).to receive(:time_month) { Duration.new(180) }
      user.projects << project

      expect(user.total_month.to_s).to eq("00:03")
    end

    it "should return the sum of time of the tasks of all projects" do
      project = Project.new
      allow(project).to receive(:time_month) { Duration.new(1800) }
      user.projects << project
      project2 = Project.new
      allow(project2).to receive(:time_month) { Duration.new(1200) }
      user.projects << project2

      expect(user.total_month.to_s).to eq("00:50")
    end
  end

end
