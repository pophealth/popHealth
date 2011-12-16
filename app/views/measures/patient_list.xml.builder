xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.Workbook({
  'xmlns'      => "urn:schemas-microsoft-com:office:spreadsheet", 
  'xmlns:o'    => "urn:schemas-microsoft-com:office:office",
  'xmlns:x'    => "urn:schemas-microsoft-com:office:excel",    
  'xmlns:html' => "http://www.w3.org/TR/REC-html40",
  'xmlns:ss'   => "urn:schemas-microsoft-com:office:spreadsheet" 
  }) do

  xml.Styles do
   xml.Style 'ss:ID' => 'Default', 'ss:Name' => 'Normal' do
     xml.Alignment 'ss:Vertical' => 'Bottom'
     xml.Borders
     xml.Font 'ss:FontName' => 'Verdana'
     xml.Interior
     xml.NumberFormat
     xml.Protection
   end
   xml.Style 'ss:ID' => 's22' do
     xml.NumberFormat 'ss:Format' => 'General Date'
   end
  end
 
  xml.Worksheet 'ss:Name' => 'Patients' do
    xml.Table do
      
      # Header
      xml.Row do
        ['First Name', 'Last Name', 'Age', 'Date of Birth', 'Gender', 'Numerator', 'Denominator', 'Exclusion', "Exclusion Rationale"].each do |column_name|
          xml.Cell do
            xml.Data column_name, 'ss:Type' => 'String'
          end          
        end
      end
      
      # Rows
      @records.each do |record_container|
        record = record_container['value']
        xml.Row do
          xml.Cell do
            xml.Data record['first'], 'ss:Type' => 'String'
          end
          xml.Cell do
            xml.Data record['last'], 'ss:Type' => 'String'
          end
          xml.Cell do
            xml.Data age_from_time(record['birthdate']) || 'UNK', 'ss:Type' => 'String'
          end
          xml.Cell do
            xml.Data dob(record['birthdate'])|| 'UNK', 'ss:Type' => 'String'
          end
          xml.Cell do
            xml.Data record['gender'], 'ss:Type' => 'String'
          end
          if (record['manual_exclusion'])
            xml.Cell do
              xml.Data false, 'ss:Type' => 'String'
            end
            xml.Cell do
              xml.Data false, 'ss:Type' => 'String'
            end
            xml.Cell do
              xml.Data true, 'ss:Type' => 'String'
            end
            xml.Cell do
              exclusion = @manual_exclusions[record['medical_record_id']] if @manual_exclusions[record['medical_record_id']]
              xml.Data "Manual: #{exclusion.rationale} (excluded by: #{exclusion.user.full_name} on #{exclusion.created_at.strftime("%m/%d/%Y")})", 'ss:Type' => 'String'
            end
          else
            xml.Cell do
              xml.Data record['numerator'], 'ss:Type' => 'String'
            end
            xml.Cell do
              xml.Data record['denominator'], 'ss:Type' => 'String'
            end
            xml.Cell do
              xml.Data record['exclusions'], 'ss:Type' => 'String'
            end
            xml.Cell do
              xml.Data (record['exclusions'] ? "Automatic" : ''), 'ss:Type' => 'String'
            end
          end
        end
      end
      
    end
  end
  
end