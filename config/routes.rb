Spree::Core::Engine.add_routes do

  get '/gallery', :to => 'custom_products#index'
  get '/blendit', :to => 'custom_products/build#pick_flavors'
  get '/myblends', :to => 'users#myblends'
  
  resource :label_templates 
  resources :custom_products do
    resources :build, controller: 'custom_products/build'
    resource :image
  end
  
  resources :products do
    resources :images do
      collection do
        post :update_positions
      end
    end
    member do
      get :customize
    end
    
    resource :product_labels
  end
  
  namespace :admin do
    resources :products do
      member do
        get :toggle_customizable
      end
    end
    resource :blendable_products_settings, :only => ['show', 'update', 'edit']
    
    resources :label_templates do
      collection do
        post :update_positions
        post :refresh_labels
        post :reprocess_images
      end
    end
    resources :blendable_taxons do
      collection do
        post :update_positions
      end

      member do
        get :get_children
      end
      resources :products
    end
  end
end