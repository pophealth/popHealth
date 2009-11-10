ActionController::Routing::Routes.draw do |map|
  map.connect 'popconnect/upload', :controller => 'popconnect', :action => 'upload'
  map.connect 'popconnect/patient_record_save', :controller => 'popconnect', :action => 'patient_record_save'
  map.resources :reports, :popconnect
  map.root :popconnect
end