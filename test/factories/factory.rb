require 'factory_girl'
require File.expand_path(File.dirname(__FILE__) + '/factory_hash')

# ==========
# = USERS =
# ==========
Factory.define :user do |u| 
  u.sequence(:email) { |n| "testuser#{n}@test.com"} 
  u.password 'password' 
  u.password_confirmation 'password'
  u.first_name 'first'
  u.last_name 'last'
  u.sequence(:username) { |n| "testuser#{n}"}
  u.admin false
  u.approved true
  u.agree_license true
end

Factory.define :admin, :parent => :user do |u|
  u.admin true
end

Factory.define :unapproved_user, :parent => :user do |u|
  u.approved false
end

Factory.define :user_w_selected_measures, :parent => :user do |u|
  u.after_create {|u| Factory(:selected_measure, :username => u.username)}
end

Factory.define :selected_measure, :class => FactoryHash do |u| 
  u.id "0032"
  u.subs []
  u.name "Cervical Cancer Screening"
  u.category "Women's Health"
  u.description "Women from 21 to 64 years old who received one or more Pap tests."
  u.username "andy"
  u.after_build {|event| event.collection('selected_measures')}
end