require File.dirname(__FILE__) + '/../spec_helper'

describe SystemMessage do
  it "can be authored by administrators" do
    SystemMessage.new(:body => 'hi world',
      :author => mock_model(User, :administrator? => true)).should be_valid
  end

  it "cannot be authored by non-administrators" do
    SystemMessage.new(:body => 'hi world',
      :author => mock_model(User, :administrator? => false)).should_not be_valid
  end

  it "can be updated by administrators" do
    message = SystemMessage.new :body => 'hi world',
      :author => mock_model(User, :administrator? => true)
    message.updater = mock_model(User, :administrator? => true)
    message.should be_valid
  end

  it "cannot be updated by non-administrators" do
    message = SystemMessage.new :body => 'hi world',
      :author => mock_model(User, :administrator? => true)
    message.updater = mock_model(User, :administrator? => false)
    message.should_not be_valid
  end

  it "must have a body" do
    SystemMessage.new(:body => '',
      :author => mock_model(User, :administrator? => true)).should_not be_valid
  end
end
