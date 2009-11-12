require File.dirname(__FILE__) + '/../spec_helper'

class FakeSection
  extend ImportHelper
  
  def self.template_id
    "2.16.840.1.113883.10.20.1.8"
  end
  
  def self.entry_xpath
    "cda:entry/cda:substanceAdministration"
  end
end

describe ImportHelper do
  before do
    @document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/joe_c32.xml'))
  end
  
  it "should find a section in a C32" do
    section = FakeSection.section(@document)
    
    section.should_not be_nil
    title_element = section.elements['title']
    title_element.should_not be_nil
    title_element.text.should == 'Medications'
    
  end
  
  it "should find entities in a C32 section" do
    section = FakeSection.section(@document)
    entries = FakeSection.entries(section)
    entries.should_not be_nil
    entries.size.should == 5 # Joe's rockin' some meds
  end
  
  it "should be able to wrap an REXML::Element to provide convenience methods" do
    FakeSection.with_element(@document) do |element|
      element.should respond_to(:find_first)
      element.should respond_to(:find_all)
    end
  end
end

describe ElementWrapper do
  before do
    document = REXML::Document.new("<food><bacon><awesome/></bacon><cheese/><cheese/></food>")
    @wrapper = ElementWrapper.new(document)
  end
  
  it 'should find the first element given an XPath expression' do
    bacon = @wrapper.find_first("//food/bacon")
    bacon.should_not be_nil
    bacon.name.should == 'bacon'
  end
  
  it 'should find all of the elements matching a given XPath expression' do
    cheeses = @wrapper.find_all("//food/cheese")
    cheeses.should_not be_nil
    cheeses.size.should == 2
  end
end