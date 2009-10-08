ActionController::Routing::Routes.draw do |map|
  map.resources :reports, :popconnect
  map.root :popconnect
end