# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'
require File.expand_path(File.dirname(__FILE__) + '/laika_spec_helper')

ModelFactory.configure do
  default(Setting) do
    name  { |i| "factory setting #{i}" }
    value { |i| "factory value #{i}" }
  end

  default(ContentError) do
    validator { 'factory' }
  end

  default(Patient) do
    name { "Harry Manchester" }
    user { User.factory.create }
    registration_information { RegistrationInformation.factory.create(:patient => self) }
    advance_directive        { AdvanceDirective.factory.create(:patient => self) }
    allergies                { [Allergy.factory.create(:patient => self)] }
    conditions               { [Condition.factory.create(:patient => self)] }
    encounters               { [Encounter.factory.create(:patient => self)] }
    immunizations            { [Immunization.factory.create(:patient => self)] }
    information_source       { InformationSource.factory.create(:patient => self) }
    insurance_providers      { [InsuranceProvider.factory.create(:patient => self)] }
    languages                { [Language.factory.create(:patient => self)] }
    medical_equipments       { [MedicalEquipment.factory.create(:patient => self)] }
    medications              { [Medication.factory.create(:patient => self)] }
    patient_identifiers      { [PatientIdentifier.factory.create(:patient => self)] }
    procedures               { [Procedure.factory.create(:patient => self)] }
    providers                { [Provider.factory.create(:patient => self)] }
    results                  { [Result.factory.create(:patient => self)] }
    support                  { Support.factory.create(:patient => self) }
    vital_signs              { [VitalSign.factory.create(:patient => self)] }
  end

  default(InsuranceProvider) do
    insurance_provider_patient { InsuranceProviderPatient.factory.create(:insurance_provider => self) }
    insurance_provider_subscriber { InsuranceProviderSubscriber.factory.create(:insurance_provider => self) }
    insurance_provider_guarantor { InsuranceProviderGuarantor.factory.create(:insurance_provider => self) }
  end

  default(User) do
    email { |i| "factoryuser#{i}@example.com" }
    first_name { "Harry" }
    last_name { "Manchester" }
    password { "secret " }
    password_confirmation { password }
  end

  default(Vendor) do
    public_id { |i| "FACTORYVENDOR#{i}" }
    user { User.factory.create }
  end

  default(TestPlan) do
    patient { Patient.factory.create }
    user { User.factory.create }
    vendor { Vendor.factory.create }
  end

  default(XdsProvideAndRegisterPlan) do
    patient { Patient.factory.create }
    user { User.factory.create }
    vendor { Vendor.factory.create }
    test_type_data { XDS::Metadata.new }
  end

  default(ClinicalDocument) do
    size { 256 }
    filename { 'factory_document' }
  end

end


Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  # 
  # For more information take a look at Spec::Example::Configuration and Spec::Runner
end
