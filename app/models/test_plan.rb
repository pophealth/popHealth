# 
# This is the base type for test plans. To add a new test plan type you must
# subclass TestPlan and declare a name using +test_name+:
#
#  class MyAwesomeTestPlan < TestPlan
#    test_name "My Awesome Test"
#  end
#
# To use the test plan you need to add it to the global list:
#
#  Laika::TEST_PLAN_TYPES[MyAwesomeTestPlan.test_name] = MyAwesomeTestPlan
#
# This list is initialized in config/initializers/load_test_plan_types.rb.
# If you want to add a new test plan type to Laika you should add it there.
#
# Test plans use an internal state machine to track progress. All test
# plans start out in the +pending+ state. You can use the methods +pass+
# or +fail+ to change the state:
#
#  plan = TestPlan.new
#  plan.state             #=> 'pending'
#  plan.tap(&:pass).state #=> 'passed'
#
# You cannot change the state of a plan once it has passed
# or failed, so you can only pass or fail pending tests.
#
class TestPlan < ActiveRecord::Base
  belongs_to :user
  belongs_to :vendor
  has_one    :patient,           :dependent => :destroy
  belongs_to :clinical_document, :dependent => :destroy
  has_many   :content_errors,    :dependent => :destroy

  default_scope :order => 'created_at ASC'

  validates_presence_of :user_id
  validates_presence_of :vendor_id

  # Count the errors in the content_errors.
  #
  # @return [Number] Number of errors in the test results.
  def count_errors
    content_errors.count(:conditions => {:msg_type => 'error'})
  end

  # Count the warnings in the content_errors.
  #
  # @return [Number] Number of warnings in the test results.
  def count_warnings
    content_errors.count(:conditions => {:msg_type => 'warning'})
  end

  state_machine :initial => :pending do
    event :pass do
      transition :pending => :passed
    end
    event :fail do
      transition :pending => :failed
    end
  end

  # Return the normalized name of this test plan, but with underscores instead
  # of dashes. Useful for building URLs and file paths.
  #
  # @return [String] Paramterized name.
  def parameterized_name
    self.class.normalize_name(self.class.test_name).gsub('-','_')
  end

  # Accessor for the test plan type registry.
  #
  # @return [Array] Registered test plan types.
  def self.test_types
    Laika::TEST_PLAN_TYPES
  end

  # Use this in the body of sub-classes to specify that inspection is done
  # manually.
  #
  # @param [true, false] flag 
  def self.manual_inspection flag = true
    @manual_inspection = flag
  end

  # Return true if this test calls for manual inspection, false otherwise.
  #
  # @return [true, false] manual inspection flag
  def self.manual_inspection?
    !!@manual_inspection
  end

  # Return true if this test calls for manual inspection, false otherwise.
  #
  # @return [true, false] manual inspection flag
  def manual_inspection?
    self.class.manual_inspection?
  end

  # Get or set the test name.
  def self.test_name name = nil
    if name.nil?
      @test_name
    else
      @test_name = name
    end
  end

  # Get the test name.
  #
  # @return [String] test name, e.g. "XDS Provide & Register"
  def test_name
    self.class.test_name
  end

  # Return either pending_actions or completed_actions depending
  # on the test plan state.
  def test_actions
    pending? ? pending_actions : completed_actions
  end

  # Used to get and set the actions for a completed test plan.
  #
  # @param [Hash<String => Symbol>] actions available actions when pending
  def self.completed_actions actions = nil
    if actions.nil?
      @completed_actions ||= {}
    else
      @completed_actions = actions
    end
  end

  # Convenience method to get the actions for a completed test plan.
  def completed_actions
    self.class.completed_actions
  end

  # Used to get and set the actions for a pending test plan.
  #
  # @param [Hash<String => Symbol>] actions available actions when pending
  def self.pending_actions actions = nil
    if actions.nil?
      @pending_actions ||= {}
    else
      @pending_actions = actions
    end
  end

  # Convenience method to get the actions for a pending test plan.
  def pending_actions
    self.class.pending_actions
  end

  # Normalize the given name for easy comparison.
  #
  # @param [String] name non-normalized name
  # @return [String] normalized name
  def self.normalize_name name
    name.strip.downcase.gsub('_','-').gsub(/\ba?nd?\b|&/i, '-and-').gsub(/\W+/, '-')
  end
end


