Leap4Net::Application.routes.draw do

  resources :static_pages do
    collection do
      get 'why_vpn'
      get 'howto'
      get 'login'
      get 'contactus'
      get 'faq'
    end
  end

  # STATIC
  statics = %w(why_vpn howto contactus faq)
  statics.each do |i|
    match "/#{i}", :to => "static_pages##{i}", :as => i
  end


  resources :payments do
    collection do
      get :pay
      get :paypal
      get :confirm
      get :cancel
    end
  end
  
  resources :sessions do
    collection do
      post 'guest_login'
    end
  end

  resources :users do
    collection do
      post 'reset_password'
      post 'build_invitation_code'
      post 'send_password'
      get 'forgot_password'
    end

    member do
      get 'change_password'
    end
  end

  resources :orders do
    collection do
      get :success
      get :notify
      get :cancel
      get :confirm
      post :discount
    end
  end


  root :to => 'static_pages#index'
  match '/login' => 'sessions#new'

  # This line mounts Refinery's routes at the root of your application.
  # This means, any requests to the root URL of your application will go to Refinery::PagesController#home.
  # If you would like to change where this extension is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Refinery relies on it being the default of "refinery"
  mount Refinery::Core::Engine, :at => '/'

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
