PopHealth::Application.routes.draw do

  match 'measures', :to => 'measures#index', :as => :dashboard, :via => :get
  match 'measures/show/:id(/:sub_id)', :to => 'measures#show', :as => :measure, :via => :get
  match 'measures/result/:id(/:sub_id)', :to => 'measures#result', :as => :measure_result, :via => :get
  match 'measures/definition/:id(/:sub_id)', :to => 'measures#definition', :as => :measure_definition, :via => :get
  match 'measures/patients/:id(/:sub_id)', :to => 'measures#patients', :as => :patients, :via => :get
  match 'measures/select/:id', :to => 'measures#select', :as => :select, :via => :post
  match 'measures/remove/:id', :to => 'measures#remove', :as => :remove, :via => :post
  match 'measures/measure_patients/:id(/:sub_id)', :to=>'measures#measure_patients', :as => :measure_patients, :via=> :get
  match 'records', :to => 'records#create', :via => :post
  match 'measures/report', :to=>'measures#measure_report', :as => :measure_report, :via=> :get
  match 'records', :to => 'records#create', :via => :post
  match 'logout', :to => 'account#log_out', :via => :get
  match 'login', :to => 'account#login', :via => :post
  match 'forgot', :to => 'account#forgot_password'
  match 'register', :to => 'account#register', :via => :get
  match 'register', :to => 'account#create', :via => :post
  match 'account/delete', :to => 'account#delete', :via => :post
  match 'account/check_username', :to => 'account#check_username', :via => :get
  match 'account/forgot_password', :to => 'account#forgot_password', :via => :get
  match 'account/reset_password', :to => 'account#reset_password', :via => :post
  match 'account/update', :to => 'account#update',:via => :post
  
  root :to => 'measures#index'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
