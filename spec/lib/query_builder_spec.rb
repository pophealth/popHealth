require File.dirname(__FILE__) + '/../spec_helper'

describe QueryBuilder do
  it "should return a query for all the patients when passed an empty request hash" do
    request = {}
    sql_query = QueryBuilder.generate_population_query(request)
    sql_query.should_not be_nil
    sql_query.should == "select count(distinct patients.id) from patients"
  end
  
  it "should return the correct query for one parameter" do
    request = {"gender"=>["Male"]}
    sql_query = QueryBuilder.generate_population_query(request)
    sql_query.should_not be_nil
    sql_query.should == "select count(distinct patients.id) from patients, registration_information where registration_information.patient_id = patients.id and ((registration_information.gender_id = 1435361449) )"
  end
  
  it "should return the correct query for multiple bins for the same field" do
    request = {"hb_a1c"=>["<7", "7-8", "9+"]}
    sql_query = QueryBuilder.generate_population_query(request)
    sql_query.should_not be_nil
    sql_query.should == "select count(distinct patients.id) from patients, abstract_results where abstract_results.patient_id = patients.id and abstract_results.result_code = '54039-3' and ((abstract_results.value_scalar::varchar::text::int <= 7) or (abstract_results.value_scalar::varchar::text::int > 7 and abstract_results.value_scalar::varchar::text::int <= 8) or (abstract_results.value_scalar::varchar::text::int > 9) )"
  end
  
  it "should return the correct query for multiple fields from the same table" do
    request = {"diabetes"=>["Yes"], "hypertension"=>["No"]}
    sql_query = QueryBuilder.generate_population_query(request)
    sql_query.should_not be_nil
    sql_query.should == "select count(distinct patients.id) from patients, conditions where conditions.patient_id = patients.id and conditions.free_text_name = 'Diabetes mellitus disorder' and patients.id not in (select conditions.patient_id from conditions where conditions.free_text_name = 'Essential hypertension disorder')"
  end
  
  it "should return the correct query for several fields and several bins" do
    request = {"diabetes"=>["Yes"], "hb_a1c"=>["7-8", "8-9"]}
    sql_query = QueryBuilder.generate_population_query(request)
    sql_query.should_not be_nil
    sql_query.should == "select count(distinct patients.id) from patients, conditions diabetes, abstract_results hb_a1c where diabetes.patient_id = patients.id and diabetes.free_text_name = 'Diabetes mellitus disorder' and hb_a1c.patient_id = patients.id and hb_a1c.result_code = '54039-3' and ((hb_a1c.value_scalar::varchar::text::int > 7 and hb_a1c.value_scalar::varchar::text::int <= 8) or (hb_a1c.value_scalar::varchar::text::int > 8 and hb_a1c.value_scalar::varchar::text::int <= 9) )"
  end
  
end