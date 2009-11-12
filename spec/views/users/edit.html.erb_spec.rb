require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/edit.html.erb" do
  include UsersHelper
  
  before do
    @user = User.new(
      :first_name => "MyString",
      :last_name => "MyString",
      :email => "MyString",
      :company => "MyString",
      :company_url => "MyString",
      :password => "MyString",
      :password_confirmation => "MyString")
      
    @user.id = 42
    assigns[:user] = @user
  end

  it "should render edit form" do
    render "/users/edit.html.erb"
    
    response.should have_tag("form[action=#{user_path(@user)}][method=post]") do
      with_tag('input#user_first_name[name=?]', "user[first_name]")
      with_tag('input#user_last_name[name=?]', "user[last_name]")
      with_tag('input#user_email[name=?]', "user[email]")
      with_tag('input#user_company[name=?]', "user[company]")
      with_tag('input#user_company_url[name=?]', "user[company_url]")
      with_tag('input#user_password[name=?]', "user[password]")
      with_tag('input#user_password_confirmation[name=?]', "user[password_confirmation]")
    end
  end
end


