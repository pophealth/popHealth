xml.instruct!
xml.instruct! "xml-stylesheet", :type => "text/xsl", :href => controller.relative_url_root + "/schemas/generate_and_format.xsl"
return @patient.to_c32(xml)