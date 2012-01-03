class Entry

  include Mongoid::Document

  embedded_in :entry_list, polymorphic: true

  field :description, type: String
  field :time, type: Integer
  field :start_time, type: Integer
  field :end_time, type: Integer
  field :status, type: Symbol
  field :codes, type: Hash
  field :value, type: Hash

  def single_code_value?
    codes.size == 1 && codes.first[1].size == 1
  end

  def codes_to_s
    codes.map {|code_set, codes| "#{code_set}: #{codes.join(', ')}"}.join(' ')
  end
  
  def times_to_s
    if start_time.present? || end_time.present?
      start_string = start_time ? Time.at(start_time).to_formatted_s(:long_ordinal) : 'UNK'
      end_string = end_time ? Time.at(end_time).to_formatted_s(:long_ordinal) : 'UNK'
      "#{start_string} - #{end_string}"
    elsif time.present?
      Time.at(time).to_formatted_s(:long_ordinal)
    end
  end
  
  def to_effective_time(xml)
    if time.present?
      xml.effectiveTime("value" => Time.at(time).utc.to_formatted_s(:number))
    else
      xml.effectiveTime do
        if start_time.present?
          xml.low("value" => Time.at(start_time).utc.to_formatted_s(:number))
        else
          xml.low("nullFlavor" => "UNK")
        end
        if end_time.present?
          xml.high("value" => Time.at(end_time).utc.to_formatted_s(:number))          
        else
          xml.high("nullFlavor" => "UNK")          
        end
      end
    end
  end
end