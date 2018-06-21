Spree::Core::Engine.add_routes do
  namespace :admin do
    resource :filters, only: [:new, :create]
  end
end
