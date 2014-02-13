PopHealth::Application.routes.draw do

  apipie

  devise_for :users, :controllers => {:registrations => "registrations"}

  get "admin/users"
  post "admin/promote"
  post "admin/demote"
  post "admin/approve"
  post "admin/disable"
  post "admin/update_npi"
  get "admin/patients"
  put "admin/upload_patients"
  delete "admin/remove_patients"
  delete "admin/remove_caches"
  delete "admin/remove_providers"

  get "logs/index"
  
  match 'provider/:npi', :to => "measures#index", :as => :provider_dashboard, :via => :get
  
  match 'records', :to => 'records#create', :via => :post
  

  root :to => 'home#index'
    
  resources :providers do
    resources :patients do
      collection do
        get :manage
        put :update_all
      end
    end
    
    member do
      get :merge_list
      put :merge
    end
  end
  
  resources :teams

  namespace :api do
    match 'reports/qrda_cat3.xml', :to =>'reports#cat3', :format => :xml
    resources :providers do
      resources :patients do
        collection do
          get :manage
          put :update_all
        end
      end
    end
    resources :patients do
      member do
        get :results
      end
    end

    resources :measures
    resources :queries do
       member do
        get :patients
        get :patient_results
        put :recalculate
       end
    end
  end
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
