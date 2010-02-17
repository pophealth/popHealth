# This class provides helper methods for working with sections in a C32 document
# Users should extend this module in their classes. For this module to work properly
# it expects a template_id, import_entries and entry_xpath class methods to be provided by the class
# extending it
module ImportHelper
  DEFAULT_NAMESPACES = {"cda"=>"urn:hl7-org:v3"}
  
  # Gets a secton Element. Will call template_id to find the appropriate id to place in it's XPath expression
  def section(document)
    REXML::XPath.first(document,"//cda:section[cda:templateId[@root = '#{template_id}']]", DEFAULT_NAMESPACES)
  end
  
  # Using a section Element, this method will pull out the entries. Entries are the C32 term for data points in a document
  # Like an individual medication. This will call the entry_xpath method to find the XPath expression that should be used
  # to find the entries. You don't need to provide an XPath expression that will return just the entry tag, as the useful
  # data is often nested several tags down.
  def entries(section_element)
    REXML::XPath.match(section_element, entry_xpath, DEFAULT_NAMESPACES)
  end
  
  # Pulls the entry elements from the section element. Once it has the entry Elements, it will pass them to an import_entry
  # method to do the job of extracting the data and putting it into an ActiveRecord object
  def import_entries(section_element)
    if section_element
      entry_elements = entries(section_element)
      entry_elements.map {|ee| import_entry(ee)}
    else
      Array.new
    end
  end

  # Helper method that wraps an elemen in an ElementWrapper that has some methods to shorten up boilerplate REXML code
  def with_element(element)
    wrapped_element = ElementWrapper.new(element)
    yield wrapped_element
  end

  def deref(code)
    if code
      ref = REXML::XPath.first(code,"cda:reference",MatchHelper::DEFAULT_NAMESPACES)
      if ref
        REXML::XPath.first(code.document,"//cda:content[@ID=$id]/text()",MatchHelper::DEFAULT_NAMESPACES,{"id"=>ref.attributes['value'].gsub("#",'')}) 
      else
        nil
      end
    end
  end
end

# Class that wraps an REXML::Element to provide convenience methods for working with XPath
class ElementWrapper
  def initialize(element)
    @element = element
  end
  
  def find_first(xpath)
    REXML::XPath.first(@element, xpath, ImportHelper::DEFAULT_NAMESPACES)
  end
  
  def find_all(xpath)
    REXML::XPath.match(@element, xpath, ImportHelper::DEFAULT_NAMESPACES)
  end
end