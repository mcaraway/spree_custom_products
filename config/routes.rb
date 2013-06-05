Spree::Core::Engine.routes.draw do
  # Add your extension routes here
end


Spree::Core::Engine.routes.prepend do  
  match '/blendit', :to => 'products#new'
  match '/myblends', :to => 'users#myblends'
  
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
    
    resources :label_templates do
      collection do
        post :update_positions
        post :refresh_labels
        post :reprocess_images
      end
    end
  end
end