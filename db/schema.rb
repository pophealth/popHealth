# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100301162247) do

  create_table "abstract_results", :force => true do |t|
    t.string  "result_id"
    t.date    "result_date"
    t.string  "result_code"
    t.string  "result_code_display_name"
    t.string  "status_code"
    t.string  "type"
    t.string  "value_scalar"
    t.string  "value_unit"
    t.integer "code_system_id"
    t.integer "patient_id"
    t.integer "result_type_code_id"
    t.integer "act_status_code_id"
    t.string  "organizer_id"
    t.integer "loinc_lab_code_id"
  end

  add_index "abstract_results", ["patient_id"], :name => "index_abstract_results_on_patient_id"
  add_index "abstract_results", ["type"], :name => "index_abstract_results_on_type"

  create_table "act_status_codes", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "addresses", :force => true do |t|
    t.string  "street_address_line_one"
    t.string  "street_address_line_two"
    t.string  "city"
    t.string  "state"
    t.string  "postal_code"
    t.integer "iso_country_id"
    t.integer "addressable_id"
    t.string  "addressable_type"
  end

  add_index "addresses", ["addressable_id", "addressable_type"], :name => "index_addresses_on_addressable_id_and_addressable_type"

  create_table "advance_directive_status_codes", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "advance_directive_types", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "advance_directives", :force => true do |t|
    t.date    "start_effective_time"
    t.date    "end_effective_time"
    t.string  "free_text"
    t.integer "advance_directive_type_id"
    t.integer "patient_id",                       :null => false
    t.integer "advance_directive_status_code_id"
  end

  add_index "advance_directives", ["patient_id"], :name => "index_advance_directives_on_patient_id"

  create_table "adverse_event_types", :force => true do |t|
    t.string "name"
    t.string "code"
    t.string "description"
  end

  create_table "allergies", :force => true do |t|
    t.date    "start_event"
    t.date    "end_event"
    t.integer "adverse_event_type_id"
    t.string  "free_text_product"
    t.string  "product_code"
    t.integer "severity_term_id"
    t.integer "patient_id",             :null => false
    t.integer "allergy_status_code_id"
    t.integer "allergy_type_code_id"
  end

  add_index "allergies", ["patient_id"], :name => "index_allergies_on_patient_id"

  create_table "allergy_status_codes", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "allergy_type_codes", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "clinical_documents", :force => true do |t|
    t.integer "size"
    t.string  "content_type"
    t.string  "filename"
    t.string  "doc_type"
  end

  create_table "code_systems", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "comments", :force => true do |t|
    t.string  "text"
    t.integer "commentable_id"
    t.string  "commentable_type"
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"

  create_table "conditions", :force => true do |t|
    t.date    "start_event"
    t.date    "end_event"
    t.integer "problem_type_id"
    t.string  "free_text_name"
    t.integer "patient_id",      :null => false
  end

  create_table "contact_types", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "content_errors", :force => true do |t|
    t.string  "section"
    t.string  "subsection"
    t.string  "field_name"
    t.string  "error_message",   :limit => 2000
    t.string  "location"
    t.string  "msg_type",                        :default => "error"
    t.string  "validator",                                            :null => false
    t.string  "inspection_type"
    t.integer "test_plan_id"
  end

  add_index "content_errors", ["msg_type"], :name => "index_content_errors_on_msg_type"
  add_index "content_errors", ["test_plan_id"], :name => "index_content_errors_on_test_plan_id"

  create_table "coverage_role_types", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "encounter_location_codes", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "encounter_types", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "encounters", :force => true do |t|
    t.string   "encounter_id"
    t.string   "free_text"
    t.string   "name"
    t.date     "encounter_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "patient_id",                 :null => false
    t.integer  "encounter_location_code_id"
    t.string   "location_name"
    t.integer  "encounter_type_id"
  end

  add_index "encounters", ["patient_id"], :name => "index_encounters_on_patient_id"

  create_table "ethnicities", :force => true do |t|
    t.string "name"
    t.string "code"
    t.string "hierarchy"
  end

  create_table "field_configurations", :force => true do |t|
    t.string "name"
    t.string "ccd_module"
    t.string "module_field"
    t.string "codes"
    t.string "bins"
    t.string "symbol"
  end

  create_table "genders", :force => true do |t|
    t.string "name"
    t.string "code"
    t.string "description"
  end

  create_table "immunizations", :force => true do |t|
    t.boolean  "refusal"
    t.date     "administration_date"
    t.string   "lot_number_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vaccine_id"
    t.integer  "no_immunization_reason_id"
    t.integer  "patient_id",                :null => false
  end

  add_index "immunizations", ["patient_id"], :name => "index_immunizations_on_patient_id"

  create_table "information_sources", :force => true do |t|
    t.date    "time"
    t.string  "organization_name"
    t.string  "document_id"
    t.integer "patient_id",        :null => false
  end

  add_index "information_sources", ["patient_id"], :name => "index_information_sources_on_patient_id"

  create_table "insurance_provider_guarantors", :force => true do |t|
    t.date    "effective_date"
    t.integer "insurance_provider_id", :null => false
  end

  add_index "insurance_provider_guarantors", ["insurance_provider_id"], :name => "index_insurance_provider_guarantors_on_insurance_provider_id"

  create_table "insurance_provider_patients", :force => true do |t|
    t.date    "date_of_birth"
    t.integer "insurance_provider_id", :null => false
    t.string  "member_id"
    t.date    "start_coverage_date"
    t.date    "end_coverage_date"
  end

  add_index "insurance_provider_patients", ["insurance_provider_id"], :name => "index_insurance_provider_patients_on_insurance_provider_id"

  create_table "insurance_provider_subscribers", :force => true do |t|
    t.date    "date_of_birth"
    t.integer "insurance_provider_id",    :null => false
    t.string  "subscriber_id"
    t.string  "assigning_authority_guid"
  end

  add_index "insurance_provider_subscribers", ["insurance_provider_id"], :name => "index_insurance_provider_subscribers_on_insurance_provider_id"

  create_table "insurance_providers", :force => true do |t|
    t.string  "represented_organization"
    t.integer "insurance_type_id"
    t.integer "patient_id",                             :null => false
    t.integer "role_class_relationship_formal_type_id"
    t.integer "coverage_role_type_id"
    t.string  "group_number"
    t.string  "health_plan"
  end

  add_index "insurance_providers", ["patient_id"], :name => "index_insurance_providers_on_patient_id"

  create_table "insurance_types", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "iso_countries", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "iso_languages", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "iso_states", :force => true do |t|
    t.string "name"
    t.string "iso_abbreviation"
    t.string "old_format"
  end

  create_table "language_ability_modes", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "languages", :force => true do |t|
    t.integer "iso_language_id"
    t.integer "iso_country_id"
    t.integer "language_ability_mode_id"
    t.boolean "preference"
    t.integer "patient_id",               :null => false
  end

  add_index "languages", ["patient_id"], :name => "index_languages_on_patient_id"

  create_table "loinc_lab_codes", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "marital_statuses", :force => true do |t|
    t.string "name"
    t.string "code"
    t.string "description"
  end

  create_table "medical_equipments", :force => true do |t|
    t.string  "code"
    t.string  "name"
    t.string  "supply_id"
    t.date    "date_supplied"
    t.integer "patient_id",    :null => false
  end

  add_index "medical_equipments", ["patient_id"], :name => "index_medical_equipments_on_patient_id"

  create_table "medication_types", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "medications", :force => true do |t|
    t.string  "product_coded_display_name"
    t.string  "product_code"
    t.integer "code_system_id"
    t.string  "free_text_brand_name"
    t.integer "medication_type_id"
    t.string  "status"
    t.float   "quantity_ordered_value"
    t.string  "quantity_ordered_unit"
    t.date    "expiration_time"
    t.integer "patient_id",                 :null => false
  end

  add_index "medications", ["patient_id"], :name => "index_medications_on_patient_id"

  create_table "no_immunization_reasons", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "patient_identifiers", :force => true do |t|
    t.integer "patient_id",         :null => false
    t.string  "affinity_domain"
    t.string  "patient_identifier"
  end

  add_index "patient_identifiers", ["patient_id"], :name => "index_patient_identifiers_on_patient_id"

  create_table "patients", :force => true do |t|
    t.string   "name"
    t.boolean  "pregnant"
    t.boolean  "no_known_allergies"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "test_plan_id"
    t.integer  "user_id"
  end

  add_index "patients", ["test_plan_id"], :name => "index_patients_on_test_plan_id"
  add_index "patients", ["user_id"], :name => "index_patients_on_user_id"

  create_table "person_names", :force => true do |t|
    t.string  "name_prefix"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "name_suffix"
    t.integer "nameable_id"
    t.string  "nameable_type"
  end

  add_index "person_names", ["nameable_id", "nameable_type"], :name => "index_person_names_on_nameable_id_and_nameable_type"

  create_table "problem_types", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "procedure_status_codes", :force => true do |t|
    t.string "code"
    t.string "description"
  end

  create_table "procedures", :force => true do |t|
    t.string  "procedure_id"
    t.string  "name"
    t.string  "code"
    t.date    "procedure_date"
    t.integer "patient_id",               :null => false
    t.integer "procedure_status_code_id"
  end

  add_index "procedures", ["patient_id"], :name => "index_procedures_on_patient_id"

  create_table "provider_roles", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "provider_types", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "providers", :force => true do |t|
    t.date    "start_service"
    t.date    "end_service"
    t.integer "provider_type_id"
    t.integer "provider_role_id"
    t.string  "provider_role_free_text"
    t.string  "organization"
    t.string  "patient_identifier"
    t.integer "patient_id",              :null => false
  end

  add_index "providers", ["patient_id"], :name => "index_providers_on_patient_id"

  create_table "races", :force => true do |t|
    t.string "name"
    t.string "code"
    t.string "hierarchy"
  end

  create_table "registration_information", :force => true do |t|
    t.date     "date_of_birth"
    t.integer  "religion_id"
    t.integer  "marital_status_id"
    t.integer  "gender_id"
    t.integer  "race_id"
    t.integer  "ethnicity_id"
    t.integer  "patient_id",         :null => false
    t.datetime "document_timestamp"
    t.integer  "affinity_domain_id"
  end

  add_index "registration_information", ["patient_id"], :name => "index_registration_information_on_patient_id"

  create_table "relationships", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "religions", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "reports", :force => true do |t|
    t.string   "title"
    t.string   "numerator_query",   :limit => 8192
    t.string   "denominator_query", :limit => 8192
    t.integer  "numerator"
    t.integer  "denominator"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "result_type_codes", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "role_class_relationship_formal_types", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.string "name",  :null => false
    t.text   "value"
  end

  add_index "settings", ["name"], :name => "index_settings_on_name", :unique => true

  create_table "severity_terms", :force => true do |t|
    t.string  "name"
    t.string  "code"
    t.integer "scale"
  end

  create_table "snowmed_problems", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "social_history", :force => true do |t|
    t.date    "start_effective_time"
    t.date    "end_effective_time"
    t.integer "social_history_type_id"
    t.integer "patient_id",             :null => false
  end

  create_table "social_history_types", :force => true do |t|
    t.string "name"
    t.string "code"
    t.string "description"
  end

  create_table "supports", :force => true do |t|
    t.date    "start_support"
    t.date    "end_support"
    t.string  "name"
    t.integer "contact_type_id"
    t.integer "relationship_id"
    t.integer "patient_id",      :null => false
  end

  add_index "supports", ["patient_id"], :name => "index_supports_on_patient_id"

  create_table "system_messages", :force => true do |t|
    t.integer  "author_id",  :null => false
    t.integer  "updater_id"
    t.text     "body",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "telecoms", :force => true do |t|
    t.string  "home_phone"
    t.string  "work_phone"
    t.string  "mobile_phone"
    t.string  "vacation_home_phone"
    t.string  "email"
    t.string  "url"
    t.integer "reachable_id"
    t.string  "reachable_type"
  end

  add_index "telecoms", ["reachable_id", "reachable_type"], :name => "index_telecoms_on_reachable_id_and_reachable_type"

  create_table "test_plans", :force => true do |t|
    t.string   "type"
    t.string   "state"
    t.text     "test_type_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "clinical_document_id"
    t.integer  "user_id",              :null => false
    t.integer  "vendor_id",            :null => false
  end

  add_index "test_plans", ["user_id", "vendor_id"], :name => "index_test_plans_on_user_id_and_vendor_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company"
    t.string   "company_url"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.boolean  "terms_of_service"
    t.boolean  "send_updates"
    t.integer  "role_id"
    t.string   "password_reset_code",       :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                                   :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "vaccines", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "vendors", :force => true do |t|
    t.string   "public_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "vendors", ["user_id"], :name => "index_vendors_on_user_id"

  create_table "zip_codes", :force => true do |t|
    t.string "zip"
    t.string "state"
    t.string "lat"
    t.string "long"
    t.string "town"
  end

end
