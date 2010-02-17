class ProcedureC32Importer 
  extend ImportHelper
  
  def self.template_id
    '2.16.840.1.113883.10.20.1.12'
  end
  
  def self.entry_xpath
    "cda:entry/cda:procedure"
  end
  
  def self.import_entry(entry_element)
    procedure = Procedure.new
    with_element(entry_element) do |element|
      
    end

    procedure
  end
end