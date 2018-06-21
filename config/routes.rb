Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :customer_segmentation, only: [:index]
  end
end
