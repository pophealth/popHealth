# To run the server:
# > gem install sinatra json
# > ruby server.rb -p 3000
# > go to http://localhost:3000/index.html

require 'rubygems'
require 'sinatra'
require 'active_support'
require 'json'

set :static, true
set :root, File.dirname(__FILE__)
set :public, File.dirname(__FILE__)

DEFAULT_OPTS = {
  :numerator_fields => {},
  :denominator_fields => {},
  :numerator => 0,
  :denominator => 0
}

@@reports = {
  1 => {
    :title => 'Aspirin Therapy',
    :numerator => 76,
    :denominator => 100,
    :denominator_fields => {:gender => ['Male', 'Female'], :age => ['18-34', '35-49', '50-64', '65-75'], :diabetes => ['Yes'], :hypertension => ['Yes']},
    :numerator_fields => {:blood_pressures => ['90-119/60-79']},
    :id => 1
  },
  2 => {
    :title => 'BP Control 1',
    :numerator => 61,
    :denominator => 100,
    :denominator_fields => {:gender => ['Male', 'Female'], :age => ['18-34', '35-49', '50-64', '65-75'], :diabetes => ['Yes'], :hypertension => ['Yes']},
    :numerator_fields => {:blood_pressures => ['90-119/60-79']},
    :id => 2
  },
  3 => {
    :title => 'BP Control 2',
    :numerator => 54,
    :denominator_fields => {:gender => ['Male', 'Female'], :age => ['18-34', '35-49', '50-64', '65-75'], :diabetes => ['Yes'], :hypertension => ['Yes']},
    :numerator_fields => {:blood_pressures => ['90-119/60-79']},
    :denominator => 100,
    :id => 3
  },
  4 => {
    :title => 'BP Control 3',
    :numerator => 31,
    :denominator => 100,
    :denominator_fields => {:gender => ['Male', 'Female'], :age => ['18-34', '35-49', '50-64', '65-75'], :diabetes => ['Yes'], :hypertension => ['Yes']},
    :numerator_fields => {:blood_pressures => ['90-119/60-79']},
    :id => 4
  },
  5 => {
    :title => 'Cholesterol Control 1',
    :numerator => 66,
    :denominator => 100,
    :denominator_fields => {:gender => ['Male', 'Female'], :age => ['18-34', '35-49', '50-64', '65-75'], :diabetes => ['Yes'], :hypertension => ['Yes']},
    :numerator_fields => {:blood_pressures => ['90-119/60-79']},
    :id => 5
  },
  6 => {
    :title => 'Cholesterol Control 2',
    :numerator => 75,
    :denominator => 100,
    :denominator_fields => {:gender => ['Male', 'Female'], :age => ['18-34', '35-49', '50-64', '65-75'], :diabetes => ['Yes'], :hypertension => ['Yes']},
    :numerator_fields => {:blood_pressures => ['90-119/60-79']},
    :id => 6
  },
  7 => {
    :title => 'Smoking Cessation',
    :numerator => 39,
    :denominator => 100,
    :denominator_fields => {:gender => ['Male', 'Female'], :age => ['18-34', '35-49', '50-64', '65-75'], :diabetes => ['Yes'], :hypertension => ['Yes']},
    :numerator_fields => {:blood_pressures => ['90-119/60-79']},
    :id => 7
  }
}

def add_random_numbers(resp = {})
  resp[:count] = 10001
  
  resp[:gender] = {
    'Male' => [rand(4100), 4100],
    'Female' => [rand(5901), 5901]
  }
  resp[:age] = {
    "18-34" => [rand(1640), 3900],
    "35-49" => [rand(2100), 2100],
    "50-64" => [rand(2100), 2100],
    "65-75" => [rand(900), 900],
    "76+" => [rand(900), 900]
  }
  resp[:medications] = {
    "Aspirin" => [rand(4300), 4300]
  }
  resp[:therapies] = {
    "Smoking Cessation" => [rand(1100), 1100]
  }
  resp[:blood_pressures] =  {
    '90-119/60-79'  => [rand(800), 800],
    '120-139/80-89' => [rand(2200), 2200],
    '140-159/90-99' => [rand(2000), 2000],
    '>160/>100' => [rand(500), 500]
  }
  resp[:cholesterol] =  {
    "<100" => [rand(800), 800],
    "100-129" => [rand(2200), 2200],
    "130-159" => [rand(2000), 2000],
    "160-189" => [rand(800), 800],
    ">190" => [rand(500), 500]
  }
  resp[:smoking] = {
    "Non-smoker" => [rand(3500), 3500],
    "Ex-smoker" => [rand(2000), 2000],
    "Smoker" => [rand(900), 900]
  }
  resp[:diabetes] = {
    "Yes" => [rand(800), 800],
    "No" => [rand(9200), 9200]
  }
  resp[:hypertension] = {
    "Yes" => [rand(700), 700],
    "No" => [rand(9300), 9300]
  }
  resp  
end

def handle_report_get(params)
  resp = {}
  resp = @@reports[params[:id].to_i]
  add_random_numbers(resp)
  resp.to_json
end

get '/reports/:id' do
  handle_report_get(params)
end

get '/reports' do
  if params[:id]
    handle_report_get(params)
  else
    resp = {
      "populationCount" => 10001,
      "populationName" => "Lahey (34234)",
      "reports" => []
    }
    @@reports.values.each {|report|
      resp['reports'] << report
    }
    resp.to_json
  end
end

post '/reports' do
  resp = {}
  
  if params[:id].blank? && (!params[:numerator].blank? || !params[:denominator].blank? || !params[:title].blank?)
    params[:id] = @@reports.length + 1
    @@reports[params[:id]] = {}
    @@reports[params[:id]][:title] = "Untitled Report " + (@@reports.values.select {|r| r[:title] =~ /Untitled Report /}.length + 1).to_s
    @@reports[params[:id]][:id] = params[:id]
  end
  
  if params[:id]
    params[:id] = params[:id].to_i
    @@reports[params[:id]][:numerator_fields] = params[:numerator] || {}
    @@reports[params[:id]][:denominator_fields] = params[:denominator] || {}
    @@reports[params[:id]][:title] = params[:title] if params[:title]
    @@reports[params[:id]][:denominator] = @@reports[params[:id]][:denominator_fields].length > 0 ? rand(1000) : 0
    @@reports[params[:id]][:numerator] = @@reports[params[:id]][:numerator_fields].length > 0 ? rand(1000) : 0
  end
  
  resp = params[:id].present? ? @@reports[params[:id]] : DEFAULT_OPTS
  resp = DEFAULT_OPTS.merge(resp)
  add_random_numbers(resp)
  resp.to_json
end