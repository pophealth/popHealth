require File.dirname(__FILE__) + '/../spec_helper'

describe Validators::Umls::UmlsValidator, "Can validate codes/code_systems " do
     before(:each) do 
       @validator = Validators::Umls::UmlsValidator.new("warning")
       @tests = [ 
                  {:codesystem=>"",:code=>"", :expected=>true}, # should return true as we dont pass judgment on code systems we dont know about
                  {:codesystem=>"2.16.840.1.113883.6.96",:code=>"46120009", :expected=>true},
                  {:codesystem=>"2.16.840.1.113883.6.96",:code=>"made up code", :expected=>false},
                  {:codesystem=>"2.16.840.1.113883.6.96",:code=>"56018004",:display_name=>'Wheezin' ,:expected=>false},
                  {:codesystem=>"2.16.840.1.113883.6.96",:code=>nil, :expected=>true} # cant say a non existant code in a code system is in valid so assume true
                ]
    end
  
  if ActiveRecord::Base::configurations["umls_test"]

      it "Should validate codes in code systems" do 
        
          valid = true
          @tests.each do |test|
             test_return = @validator.validate_code(test[:codesystem], test[:code], test[:display_name])
             test_valid = (test_return == test[:expected])
             puts "test fail-- #{test.inspect}     -- test returned #{test_return}  expect #{test[:expected]}" if !test_valid
             valid = valid &&  test_valid
          end
          
          valid.should == true
      end


      it "should validate clinical document contents "  do 
         document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/validators/valid_codes.xml'))
        errors =  @validator.validate(nil,document)
        errors.should be_empty
      end


      it "should not validate clinical document contents with bad codes in known code systems"  do 
        document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/validators/invalid_codes.xml'))
        errors =  @validator.validate(nil,document)
        errors.should_not be_empty
        #puts errors
      end
      
  end

end
