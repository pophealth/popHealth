require 'spec_helper'

describe User do
  before do
   collection_fixtures 'users'
  end
  
  
  it 'should be able to tell if a record is new' do
    u = User.new
    u.new_record?.should == true
    
    u = User.find_one({"email" => "test@test.org"}) 
    u.new_record?.should == false
  end
  
  it 'should enforce unquiness of username' do
    u = User.new({:username=>"test@test.org"})
    u.save.should == false
    u.errors[:username].length.should == 1
  end

  it 'should enforce unquiness of email' do
    u = User.new({:email=>"test@test.org"})
    u.save.should == false
    u.errors[:email].length.should == 1
  end
  
  it 'should enforce password confirmation' do
     u = User.new({:password=>"asdfsadf",:password_confirmation=>"pdiddy"})
     u.save.should == false
     u.errors[:password].nil?.should == false
  end  
  
  it 'should allow creation of a user' do
    u = User.new({:password=>"asdfsadf", :email=>"t@t.tos",:username=>"t@t.tos",:first_name=>"df", :last_name=>"xdf",:password_confirmation=>"asdfsadf"})
    u.save.should == true
    u._id.nil?.should == false
  end
  
  it 'should allow updating a user' do
     u = User.find_one({"email" => "test@test.org"}) 
     n = u.first_name
     u.first_name = "skippy"
     u.save.should == true
     u = User.find_one({"email" => "test@test.org"}) 
     u.first_name.should == "skippy"
  end
  
  it 'should allow deleting a user' do
     u = User.find_one({"email" => "test@test.org"}) 
     u.destroy
     u = User.find_one({"email" => "test@test.org"}) 
     puts u
     u.nil?.should == true
  end
  
  
  
end
