require 'spec_helper'

describe User do
  before do
   collection_fixtures 'users'
  end
  
  
  it 'should enforce unquiness of username' do
    
  end

  it 'should enforce unquiness of email' do
    
  end
  
  it 'should enforce password confirmation' do
     puts User.find({})
  end  
  
  it 'should allow creation of a user' do
    u = User.new({:password=>"asdfsadf", :email=>"t@t.tos",:username=>"t@t.tos",:first_name=>"df", :last_name=>"xdf",:password_confirmation=>"asdfsadf"})
    puts u.save
    puts u.errors
    puts u._id
  end
  
  it 'should allow updating a user' do
    
  end
  
  it 'should allow deleting a user' do
    
  end
  
  
  
end
