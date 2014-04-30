namespace :upgrade do

  task :upgrade_query_cache => :environment do
    # remove all unprocessed jobs - they will not be compatible with the updated 
    # QME. 
    Delayed::Job.all.destroy
    Mongoid.default_session["rollup_buffer"].drop
    fields = ["population_ids",
              "IPP",
              "DENOM",
              "NUMER",
              "antinumerator",
              "DENEX",
              "DENEXCEP",
              "MSRPOPL",
              "OBSERV", 
              "supplemental_data"]
    QME::QualityReport.where({status: {"$ne" => nil}}).where({"status.state" => {"$ne" => "completed"}}).destroy   
    QME::QualityReport.where({status: nil}).each do |qr|
      qr.status = {state: "completed"}
      report = QME::QualityReportResult.new
      fields.each do |field|
        report[field] = qr[field]
      end
      qr.filters = {} unless qr.filters
      qr.result = report
      qr.save
    end

  end

  task :upgrade_records => :environment do 
    Record.all.each do |r|

    end
  end

  task :upgrade_patient_cache => :environment do
    QME::PatientCache.all.each do |pc|

    end
  end

  task :upgrade_providers => :environment do
    Provider.all.each do |pro|
      pro.npi =  pro["npi"] if pro["npi"]
      pro.tin = pro["tin"] if pro["tin"]   
      pro.save
    end
  end

  task :upgrade_users => :environment do 
    User.all.each do |u|
      selected = Mongoid.default_session["selected_measures"].where({username: u.username}).collect{|sm| sm["id"]}
      u.preferences["selected_measure_ids"] = selected
      u.save
    end
  end

  task :all => [:environment,:upgrade_query_cache,:upgrade_patient_cache,:upgrade_records,:upgrade_providers,:upgrade_users] do
  end

end