
# NOTE: the measure controller should eventually be transitioned to use code similar to this in a library function.
#       however, currently refactoring the measure controller is out of scope and rake based PQRI generation is needed by Cypress for testing
class PQRIReporter
  def self.measure_report(period_start,period_end)
    selected_measures = Measure.all
    report = {}
    report[:registry_name] = nil
    report[:registry_id] = nil
    report[:provider_reports] = []
    
    report[:provider_reports] << generate_xml_report(selected_measures, period_start, period_end)
    report
  end
  
  def self.render_xml(report)
    av = ActionView::Base.new(Rails::Application::Configuration.new(Rails.root).paths['app/views'])
    av.render(:template => "measures/measure_report", :locals => {:report => report}, :layout => false)
  end
  
  def self.generate_xml_report(selected_measures, period_start, period_end)
    report = {}
    report[:start] = Time.at(period_start)
    report[:end] = Time.at(period_end)
    report[:npi] = '' 
    report[:tin] = ''
    report[:results] = []
    
    selected_measures.each do |measure|
      id = measure['id']
      sub_id = measure['sub_id']
      qr = QME::QualityReport.new(id, sub_id, 'effective_date' => period_end)
      qr.calculate(false) unless qr.calculated?
      result = qr.result
      report[:results] << {
        :id=>id,
        :sub_id=>sub_id,
        :population=>result['population'],
        :denominator=>result['denominator'],
        :numerator=>result['numerator'],
        :exclusions=>result['exclusions']
      }
    end
    report
  end
  
end