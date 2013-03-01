Refinery::Core::Engine.routes.append do

  # Frontend routes
  namespace :invication_codes do
    resources :invication_codes, :path => '', :only => [:index, :show]
  end

  # Admin routes
  namespace :invication_codes, :path => '' do
    namespace :admin, :path => 'refinery' do
      resources :invication_codes, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
