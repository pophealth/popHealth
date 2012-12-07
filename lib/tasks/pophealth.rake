namespace :pophealth do

  task :download_value_sets, [:username, :password] => :environment do |t, args|
    valuesets = Measure.all.collect {|m| m['oids']}
    errors = {}
    valuesets.flatten!
    valuesets.compact!
    valuesets.uniq!
    config = APP_CONFIG['value_sets']
    api = HealthDataStandards::Util::VSApi.new(config["ticket_url"],config["api_url"],args.username,args.password)
    RestClient.proxy = ENV["http_proxy"]
    valuesets.each_with_index do |oid,index| 
      begin
        vs_data = api.get_valueset(oid) 
        vs_data.force_encoding("utf-8") # there are some funky unicodes coming out of the vs response that are not in ASCII as the string reports to be
        doc = Nokogiri::XML(vs_data)

        doc.root.add_namespace_definition("vs","urn:ihe:iti:svs:2008")
        vs_element = doc.at_xpath("/vs:RetrieveValueSetResponse/vs:ValueSet")
        
        if vs_element && vs_element["ID"] == oid
        vs_element["id"] = oid
          vs = HealthDataStandards::SVS::ValueSet.load_from_xml(doc)
          # look to see if there is a valueset with the given oid and version already in the db
          old = HealthDataStandards::SVS::ValueSet.where({:oid=>vs.oid, :version=>vs.version}).first
          if old.nil?
           vs.save!
          end
        else
          errors[oid] = "Not Found"
        end
      rescue 
        errors[oid] = $!.message
      end
      print "\r"
      print "#{index+1} of #{valuesets.length} processed : error downloading #{errors.keys.length} valuesets"
      STDOUT.flush
    end

    if !errors.empty?
      File.open("oid_errors.txt", "w") do |f|
      f.puts errors.to_yaml
    end
      puts ""
      puts "There were errors retreiveing #{errors.keys.length} valuesets. Cypress May not work correctly without thses valusets installed."
      puts "A list of the valueset OIDs that were unable to be retrieved have been written to the file oid_errors.txt"
   end
  end
end

 