require File.dirname(__FILE__) + '/../spec_helper'

describe ClinicalDocument, "can store validation reports" do
  fixtures :clinical_documents
  
  before(:each) do
    @joe = clinical_documents(:joe_c32_clinical_document)
  end

  
  it "should be able to obtain document as an REXML::Document " do
     require "rexml/document"
     doc = @joe.as_xml_document
     doc.class.should  == REXML::Document
     # the test document has one stylesheet declaration so this should equal 1
     doc.instructions.length.should == 1
     # ask for the doc again with the stylesheet tags stripped out
     doc =  @joe.as_xml_document(true)
     doc.instructions.length.should == 0
     
     
  end
  
  
  
end