require 'json'
namespace :import do

  desc 'import patient records'
  task :patients, [:source_dir, :providers_predefined] do |t, args|
    if !args.source_dir || args.source_dir.size==0
      raise "please specify a value for source_dir"
    end
    HealthDataStandards::Import::BulkRecordImporter.import_directory(args.source_dir)
  end

  desc 'import providers from a file containing a json array of providers'
  task :providers, [:provider_json] do |t, args|
    if !args.provider_json || args.provider_json.size==0
      raise "please specify a value for provider_json"
    end
    
    providers = JSON.parse(File.new(args.provider_json).read)
    providers.each {|provider_hash| Provider.new(provider_hash).save}
    puts "imported #{providers.count} providers"
  end
  
  #bundle exec rake import:results[/Users/aquina/data/provider_data.csv,1,2,6,3,4,5,0] --trace
  #desc 'import query cache results from csv'
  #task :results, [:csv_file, :measure_id_index, :sub_id_index, :count_index,
  #                :numerator_index, :denominator_index, :exclusions_index, 
  #                :npi_index, :effective_date, :test_id] do |t, args|
  #  if !args.csv_file || args.csv_file.size==0
  #    raise "please specify a value for provider_json"
  #  end
  #  
  #  effective_date = args.effective_date || 1325394000
  #  test_id = args.test_id || 1
  #  base_fields = {
  #      "effective_date" => effective_date,
  #      "test_id" => test_id,
  #      "execution_time" => -1
  #  }
  #
  #  csv_file = File.new(args.csv_file)
  #  measure_id_ind = args.measure_id_index.to_i || 0
  #  sub_id_ind = args.sub_id_index.to_i || 1
  #  numerator_ind = args.numerator_index.to_i || 2
  #  denominator_ind = args.denominator_index.to_i || 3
  #  exclusions_ind = args.exclusions_index.to_i || 4
  #  count_ind = args.count_index.to_i || 5
  #  npi_ind = args.npi_index.to_i
  #
  #  
  #  count = 0
  #  csv_file.read.each_line do |line|
  #    count = count + 1
  #    line.gsub!(/\r\n?/,'')
  #    split_line = line.split ','
  #    next if count == 1 || split_line[measure_id_ind].nil? || split_line[measure_id_ind].empty?
  #    row = {
  #      "measure_id" => split_line[measure_id_ind],
  #      "sub_id" => split_line[sub_id_ind],
  #      "population" => split_line[denominator_ind].to_i,
  #      "denominator" => split_line[denominator_ind].to_i,
  #      "numerator" => split_line[numerator_ind].to_i,
  #      "antinumerator" => split_line[denominator_ind].to_i - split_line[numerator_ind].to_i,
  #      "exclusions" => split_line[exclusions_ind].to_i,
  #      "considered" => split_line[count_ind].to_i
  #    }
  #    row["sub_id"] = nil if row["sub_id"].empty?
  #    if (npi_ind >= 0)
  #      row["filters"]  = { "providers" => [ Provider.by_npi(split_line[npi_ind]).first.id.to_s ] }
  #    end
  #    row.merge!(base_fields)
  #    
  #    MONGO_DB['query_cache'] << row
  #
  #  end
  #  
  #  puts "imported results from csv file"
  #end
  

end
