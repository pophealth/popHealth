
module InformationSourceC32Validation

  include MatchHelper

  #Reimplementing from MatchHelper
  def section_name
    "Information Source Module"
  end


  def validate_c32(document)
    errors = []
    begin      
      author = REXML::XPath.first(document,"ancestor-or-self::/cda:author[1]", {'cda' => 'urn:hl7-org:v3'})
      if(author)
        ## TO-DO MATCH TIME ELEMENTS Required / Non Repeat cda:time
        assignedPerson = REXML::XPath.first(author,"./cda:assignedAuthor/cda:assignedPerson/cda:name", {'cda' => 'urn:hl7-org:v3'})
        errors.concat self.person_name.validate_c32(assignedPerson)
      else
        errors << ContentError.new(:section=>"InformationSource",
                                   :error_message=>"Author not found",
                                   :location=>(document)? document.xpath : '')
      end
    rescue
      errors << ContentError.new(:section => 'InformationSource', 
                                 :error_message => 'Invalid, non-parsable XML for information source data',
                                 :type=>'error',
                                 :location => document.xpath)
    end
    errors.compact
  end

  def section
    "InformationSource"
  end


end