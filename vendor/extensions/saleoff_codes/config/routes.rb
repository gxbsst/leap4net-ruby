Refinery::Core::Engine.routes.append do

  # Frontend routes
  namespace :saleoff_codes do
    resources :saleoff_codes, :path => '', :only => [:index, :show]
  end

  # Admin routes
  namespace :saleoff_codes, :path => '' do
    namespace :admin, :path => 'refinery' do
      resources :saleoff_codes, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
