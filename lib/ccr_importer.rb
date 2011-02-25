class CCRImporter
  attr_writer :record_creator, :quality_measures
  include Singleton
  
  import java.io.StringReader
  
  def initialize
    @qme = QualityMeasureEvaluator.new
    
    jc = JAXBContext.new_instance(org.astm.ccr.ContinuityOfCareRecord.java_class)
    @unmarshaller = jc.create_unmarshaller()
  end
  
  def create_patient(ccr_string)
    reader = StringReader.new(ccr_string)
    
    ccr = @unmarshaller.unmarshal(reader);
    record = @record_creator.create_record(ccr)
    @qme.evaluate(record, @quality_measures)
  end
end