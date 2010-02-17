class PersonNameC32Importer
  extend ImportHelper

  def self.import(name_element)
    name = PersonName.new
    if name_element
      with_element(name_element) do |element|
        name.name_prefix = element.find_first("cda:prefix").try(:text)
        name.first_name = element.find_first("cda:given[1]").try(:text)
        name.middle_name = element.find_first("cda:given[2]").try(:text)
        name.last_name = element.find_first("cda:family").try(:text)
        name.name_suffix = element.find_first("cda:suffix").try(:text)
      end
    end
    name
  end

end