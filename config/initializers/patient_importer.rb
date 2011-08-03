measure_ids = MONGO_DB.collection('measures').find({}, {:fields => {:id => 1}}).map {|r| r['id']}.uniq

measure_ids.each do |id|
  QME::Importer::PatientImporter.instance.add_measure(id, QME::Importer::GenericImporter.new(MONGO_DB.collection('measures').find_one({:id => id})))
end

if RUBY_PLATFORM =~ /java/ && File.exists?(Rails.root+ 'resources/ccr/jars/ccr-importer.jar')
  require 'java'
  
  Dir.glob(Rails.root+ 'resources/ccr/jars/*.jar').each do |jar_file|
    require jar_file
  end
  
  java_import javax.xml.bind.JAXBContext
  java_import java.io.InputStream
  java_import org.ohd.pophealth.ccr.importer.RecordCreator
  java_import org.ohd.pophealth.ccr.importer.Vocabulary
  java_import org.ohd.pophealth.json.MeasureReader
  java_import org.ohd.pophealth.evaluator.QualityMeasureEvaluator
  java_import java.io.FileInputStream
  java_import java.util.ArrayList
  
  require 'ccr_importer'
  
  quality_measures = ArrayList.new 
  measure_ids.each do |measure_id|
    measure_def = MONGO_DB.collection('measures').find_one({:id => measure_id})
    measure_def.delete('_id')
    quality_measure = MeasureReader.extract_quality_measure(measure_def.to_json)
    quality_measures.add(quality_measure)
  end
  
  ccr_importer = CCRImporter.instance
  ccr_importer.quality_measures = quality_measures
  
  vocab = Vocabulary.from_json(File.open(Rails.root + 'resources/ccr/ccrvocabulary.json').to_inputstream)
  ccr_importer.record_creator = RecordCreator.new(vocab)
end