class ResultC32Importer 
  extend ImportHelper
  
  include MatchHelper
  
  def self.template_id
    '2.16.840.1.113883.10.20.1.14'
  end
  
  def self.entry_xpath
    "cda:entry"
  end
  
  def self.import_entry(entry_element)
    result = Result.new
    with_element(entry_element) do |element|
      
      
    end

    result
  end
end