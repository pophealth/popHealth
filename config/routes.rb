ActionController::Routing::Routes.draw do |map|
  map.connect 'popconnect/upload', :controller => 'popconnect', :action => 'upload'
  map.connect 'popconnect/export', :controller => 'reports', :action => 'pqri_report'
  map.connect 'popconnect/patient_record_save', :controller => 'popconnect', :action => 'patient_record_save'
  map.resources :reports, :popconnect
  map.root :controller => 'popconnect', :action => 'index'
  
  map.resources :message_logs
  map.resources :atna_audits
  map.resources :vendors, :only => [:create, :update, :destroy] do |vendors|
    vendors.resources :test_plans, :only => :index
  end
  map.resources :users, :except => [:index]
  map.resources :document_locations
  map.resources :news, :singular => 'news_item'

  map.resources :settings, :only => [:index, :update]

  map.resources :patients,
      :has_one  => [:registration_information, :support, :information_source, :advance_directive, :pregnancy],
      :has_many => [:languages, :providers, :insurance_providers, 
                    :insurance_provider_patients, :insurance_provider_subscribers, 
                    :insurance_provider_guarantors, :medications, :allergies, :conditions, 
                    :results, :immunizations, :vital_signs,
                    :encounters, :procedures, :medical_equipments, :patient_identifiers],
      :member   => {:set_no_known_allergies => :post, :edit_template_info => :get, :copy => :post, :show => :get },
      :collection => { :autoCreate => :post, :list => :get }


  map.with_options :controller => 'account' do |account|
    %w[ signup login logout forgot_password reset_password ].each do |action|
      account.send(action, "/account/#{action}", :action => action)
    end
  end

  # to support autocomplete actions, include each autocomplete-able controller/action in the list
  { 'conditions' => %w[ snowmed_problem_name ] }.each do |controller, actions|
    actions.each do |action|
      map.connect "/autocomplete/#{controller}/#{action}",
        :controller => controller, :action => "auto_complete_for_#{action}"
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"
end
