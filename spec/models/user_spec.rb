require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { create(:user) }

  it "should be valid" do    
    expect(user).to be_valid
  end

  it "should require username" do    
    user.username = nil
    expect(user).to_not be_valid
  end

  it "should not allow creating duplicate usernames" do
    create(:user, username: 'test1')
    new_user = build(:user, username: 'test1')
    new_user.username = user.username
    new_user.save
    expect(new_user).to_not be_valid
  end

  it "should has registered sets to false by default" do
    user.registered = nil
    expect(user).to be_valid

    user.save
    expect(user.registered).to be_falsy
  end

end
