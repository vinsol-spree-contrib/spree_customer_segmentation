Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :customer_segments do
      get :filter, on: :collection
    end
  end
end
