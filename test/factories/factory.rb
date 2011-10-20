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

Factory.define(:provider) do |pv|
  pv.title "Dr."
  pv.given_name { %w(Robert Jane Steve Claire Joe Liana Edmund Emily Kevin Amanda Gino Michelle Dylan Jake Jessica Duane Jamie Leon Elizabeth George).sample }
  pv.family_name { %w(Smith Jones Burns Simpsons Jackson Hurt Marshall Roy Adam Miller Ellis Myers Weber Martin Edwards Kelly Campbell Darling Clark Schwartz Calloway Schmidt Sterling Cooper Draper Pryce Formby).sample }
  pv.sequence(:phone) { |n| 15555555555 + n }
  pv.sequence(:tin) { |n| 123456789 + n  }
  pv.sequence(:npi) { |n| 9238429384 + n }
  pv.organization "General Hospital"
  pv.specialty "200000000X"
end