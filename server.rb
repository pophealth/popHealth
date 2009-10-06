# To run the server:
# > gem install sinatra json
# > ruby server.rb -p 3000

require 'rubygems'
require 'sinatra'
require 'json'

set :static, true
set :root, File.dirname(__FILE__)
set :public, File.dirname(__FILE__)

DEFAULT_OPTS = {
  :numerator_fields => {},
  :denominator_fields => {:gender => ['Male']}
}

REPORT_OPTS = {
  1 => {
    :title => 'Aspirin Therapy',
    :percentage => 76
  },
  2 => {
    :title => 'BP Control 1',
    :percentage => 61
  },
  3 => {
    :title => 'BP Control 2',
    :percentage => 54,
    :denominator_fields => {:gender => ['Male', 'Female'], :age => ['18-34', '35-49', '50-64', '65-75'], :diabetes => ['Yes'], :hypertension => ['Yes']},
    :numerator_fields => {:blood_pressures => ['130/80']}
  },
  4 => {
    :title => 'BP Control 3',
    :percentage => 31
  },
  5 => {
    :title => 'Cholesterol Control 1',
    :percentage => 66
  },
  6 => {
    :title => 'Cholesterol Control 2',
    :percentage => 75
  },
  7 => {
    :title => 'Smoking Cessation',
    :percentage => 39
  }
}

def build_response_from_params(params, resp = {})
  resp[:numerator_fields] = params[:numerator] if params[:numerator]
  resp[:denominator_fields] = params[:denominator] if params[:denominator]
  resp
end

def add_random_numbers(resp = {})
  resp[:count] = 10001
  resp[:numerator] = 0
  resp[:denominator] = 4100
  resp[:gender] = {
    'Male' => [4100, 4100],
    'Female' => [0, 5901]
  }
  resp[:age] = {
    "18-34" => [1640, 3900],
    "35-49" => [861, 2100],
    "50-64" => [902, 2100],
    "65-75" => [410, 900],
    "76+" => [33, 900]
  }
  resp[:medications] = {
    "Aspirin" => [1763, 4300]
  }
  resp[:therapies] = {
    "Smoking Cessation" => [50, 1100]
  }
  resp[:blood_pressures] =  {
    "110/75" => [328, 800],
    "120/80" => [902, 2200],
    "130/80" => [820, 2000],
    "140/90" => [328, 800],
    "160/100" => [205, 500],
    "180/110+" => [41, 100]
  }
  resp[:smoking] = {
    "Non-smoker" => [1230, 3500],
    "Ex-smoker" => [902, 2000],
    "Smoker" => [50, 900]
  }
  resp[:diabetes] = {
    "Yes" => [326, 800],
    "No" => [3772, 9200]
  }
  resp[:hypertension] = {
    "Yes" => [287, 700],
    "No" => [3813, 9300]
  }
  resp  
end

def handle_report_get(params)
  resp = {}
  resp = REPORT_OPTS[params[:id].to_i].merge(resp)
  resp = DEFAULT_OPTS.merge(resp)
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
    '{
      "populationCount": 10001,
      "populationName": "Lahey (34234)",
      "reports": [
        {
          "name": "Aspirin Therapy",
          "percentage": 76,
          "id": 1
        },
        {
          "name": "BP Control 1",
          "percentage": 61,
          "id": 2
        },
        {
          "name": "BP Control 2",
          "percentage": 54,
          "id": 3
        },
        {
          "name": "BP Control 3",
          "percentage": 31,
          "id": 4
        },
        {
          "name": "Cholesterol Control 1",
          "percentage": 66,
          "id": 5
        },
        {
          "name": "Cholesterol Control 2",
          "percentage": 75,
          "id": 6
        },
        {
          "name": "Smoking Cessation",
          "percentage": 39,
          "id": 7
        },
      ]
    }'
  end
end

post '/reports' do
  resp = {}
  resp = REPORT_OPTS[params[:id]].merge(resp) if params[:id]
  build_response_from_params(params, resp)
  resp = DEFAULT_OPTS.merge(resp)
  add_random_numbers(resp)
  resp.to_json
end