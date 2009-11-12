class ClinicalDocument < ActiveRecord::Base

  has_attachment :content_type => 'text/xml', 
                 :storage => :file_system, 
                 :max_size => 500.kilobytes

  has_one :test_plan

  attr_accessible :doc_type
  # prevent records from being created when there is no associated file data
  validates_presence_of :filename, :size




  # return the contents of the document as an REXML::Document
  # if the current data is nil attachemnt_foo  will throw a conversion error
  def as_xml_document(remove_stylesheets = false)  
    # pulling this in instead of calling fro it from the file store everytime we need it
    data = current_data
    data = data.gsub(/\<\?xml\-stylesheet.*\?\>/,'') if  remove_stylesheets
    data  ? REXML::Document.new(data) : nil
  end
 


end
