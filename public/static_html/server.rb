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
  resp[:count] = 4948
  
  resp[:gender] = {
    'Male' => [rand(4100), 4100],
    'Female' => [rand(5901), 5901]
  }
  resp[:age] = {
    "<18" => [rand(1640), 3900],
    "18-30" => [rand(1640), 3900],
    "30-40" => [rand(2100), 2100],
    "40-50" => [rand(2100), 2100],
    "50-60" => [rand(900), 900],
    "60-70" => [rand(900), 900],
    "70-80" => [rand(900), 900],
    "80+" => [rand(900), 900]
  }
  resp[:medications] = {
    "Aspirin" => [rand(4300), 4300]
  }
  resp[:therapies] = {
    "Smoking Cessation" => [rand(1100), 1100]
  }
  resp[:blood_pressures] =  {
    '110/70'  => [rand(800), 800],
    '120/80' => [rand(2200), 2200],
    '140/90' => [rand(2000), 2000],
    '160/100' => [rand(2000), 2000],
    '180/110+' => [rand(500), 500]
  }
  resp[:ldl_cholesterol] =  {
    "100" => [rand(800), 800],
    "100-120" => [rand(2200), 2200],
    "130-160" => [rand(2000), 2000],
    "160-180" => [rand(800), 800],
    "180+" => [rand(500), 500]
  }
  resp[:smoking] = {
    "Non-Smoker" => [rand(3500), 3500],
    "Current Smoker" => [rand(2000), 2000]
  }
  resp[:diabetes] = {
    "Yes" => [rand(800), 800],
    "No" => [rand(9200), 9200]
  }
  resp[:hypertension] = {
    "Yes" => [rand(700), 700],
    "No" => [rand(9300), 9300]
  }
  resp[:ischemic_vascular_disease] = {
    "Yes" => [rand(700), 700],
    "No" => [rand(9300), 9300]
  }
  resp[:lipoid_disorder] = {
    "Yes" => [rand(700), 700],
    "No" => [rand(9300), 9300]
  }
  resp[:colorectal_cancer_screening] = {
    "Yes" => [rand(700), 700],
    "No" => [rand(9300), 9300]
  }
  resp[:mammography] = {
    "Yes" => [rand(700), 700],
    "No" => [rand(9300), 9300]
  }
  resp[:influenza_vaccine] = {
    "Yes" => [rand(700), 700],
    "No" => [rand(9300), 9300]
  }
  resp[:hb_a1c] = {
    "<7" => [rand(700), 700],
    "7-8" => [rand(9300), 9300],
    "8-9" => [rand(9300), 9300],
    "9+" => [rand(9300), 9300]
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
      "populationCount" => 4948,
      "populationName" => "Sagacious Healthcare Services",
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