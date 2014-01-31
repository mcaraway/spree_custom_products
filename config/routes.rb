Spree::Core::Engine.routes.draw do
  # Add your extension routes here
end

Spree::Core::Engine.add_routes do

  get '/gallery', :to => redirect('/t/categories/custom-blend')
  get '/blendit', :to => 'products#new'
  get '/myblends', :to => 'users#myblends'
  
  resource :label_templates 
  
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