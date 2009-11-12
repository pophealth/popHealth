xml.instruct!
xml.instruct! "xml-stylesheet", :type => "text/xsl", :href => controller.relative_url_root + "/schemas/file_and_display.xsl"
return @patient.to_c32(xml)
