require ::File.expand_path('../../../config/environment',  __FILE__)
require 'pqri_reporter'
require 'fileutils'

namespace :pqri do

  desc 'Generate an aggregate PQRI for the currently loaded patients and measures'
  task :report, [:effective_date] do |t, args|
    
    raise "You must specify an effective date" unless args.effective_date
    FileUtils.mkdir_p File.join(".","tmp")
    
    effective_date = args.effective_date.to_i
    period_start = 3.months.ago(Time.at(effective_date)).to_i
    report_result = PQRIReporter.measure_report(period_start, effective_date)
    report_xml = PQRIReporter.render_xml(report_result)
    outfile = File.join(".","tmp","pophealth_pqri.xml")
    File.open(outfile, 'w') {|f| f.write(report_xml) }
    puts "wrote result to: #{outfile}"

  end

end