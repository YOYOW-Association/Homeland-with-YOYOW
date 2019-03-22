Homeland::Site::Engine.routes.draw do
  resources :sites
  namespace :admin do
    resources :sites do
      member do
        post :undestroy
      end
    end
    resources :site_nodes
  end
end
