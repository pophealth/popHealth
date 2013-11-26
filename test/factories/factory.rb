require 'factory_girl'
require File.expand_path(File.dirname(__FILE__) + '/factory_hash')
require File.expand_path(File.dirname(__FILE__) + '/factory_utils')

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

Factory.define :user_w_npi, :parent => :user do |u|
  u.npi "9238429385"
  u.staff_role false
end

Factory.define :provider do |pv|
  pv.title "Dr."
  pv.given_name { %w(Robert Jane Steve Claire Joe Liana Edmund Emily Kevin Amanda Gino Michelle Dylan Jake Jessica Duane Jamie Leon Elizabeth George).sample }
  pv.family_name { %w(Smith Jones Burns Simpsons Jackson Hurt Marshall Roy Adam Miller Ellis Myers Weber Martin Edwards Kelly Campbell Darling Clark Schwartz Calloway Schmidt Sterling Cooper Draper Pryce Formby).sample }
  pv.sequence(:phone) { |n| 15555555555 + n }
  pv.sequence(:tin) { |n| 123456789 + n  }
  pv.sequence(:npi) { |n| 9238429384+ n }
  pv.organization { FactoryGirl.build(:organization)}
  pv.specialty "200000000X"
end

Factory.define :provider_with_known_npi, :parent => :provider do |p|
  p.npi "9238429385"
end

Factory.define(:organization) do |org|
  org.name "General Hospital"
end

Factory.define :record do |r|
  r.first { %w(Robert Jane Steve Claire Joe Liana Edmund Emily Kevin Amanda Gino Michelle Dylan Jake Jessica Duane Jamie Leon Elizabeth George).sample }
  r.last { %w(Smith Jones Burns Simpsons Jackson Hurt Marshall Roy Adam Miller Ellis Myers Weber Martin Edwards Kelly Campbell Darling Clark Schwartz Calloway Schmidt Sterling Cooper Draper Pryce Formby).sample }
  r.medical_record_number { (0...10).map{ ('0'..'9').to_a[rand(10)] }.join.to_s }
  r.birthdate { between(Time.gm(1970, 1, 1), Time.gm(2010, 9, 1)) }
  r.gender { %w(M F).sample }
  r.measures {}
end

Factory.define :provider_performance do |pp|
  pp.after_build do |pp| 
    pp.start_date = between(Time.gm(1970, 1, 1), Time.gm(2010, 10, 1)) unless pp.start_date
    if Random.new.rand(1..100) > 90 || pp.end_date
      pp.end_date = between(pp.start_date, Time.gm(2010, 12, 31)) unless pp.end_date
    end  
    pp.provider_id = Factory(:provider).id unless pp.provider_id
  end
end

Factory.define :base_query_cache, :class => FactoryHash do |qc|
  qc.measure_id "measure_id"
  qc.sub_id nil
  qc.effective_date Time.now.to_i
  qc.test_id nil
  qc.filters nil
  qc.population 0
  qc.denominator 0
  qc.numerator 0
  qc.antinumerator 0
  qc.exclusions 0 
  qc.after_build {|event| QME::QualityReport.normalize_filters(event.filters)}
  qc.after_build {|event| event.collection('query_cache')}
end

Factory.define :query_cache, parent: :base_query_cache do |qc|
  qc.effective_date User::DEFAULT_EFFECTIVE_DATE.to_i
  qc.population 20
  qc.denominator 15
  qc.numerator 10
  qc.antinumerator 5
end