module ProvidersHelper

  def quality_report_status(uuid)
    QME::QualityReport.status(uuid)
  end

  def result_hash(measure_id, sub_id, effective_date, filters)
    qr = QME::QualityReport.new(measure_id, sub_id, 'effective_date' => effective_date, 'filters' => filters)
    result = {}
    if qr.calculated?
      result.merge!(qr.result)
    end
    
    result
  end
  
  
  
end
