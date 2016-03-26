Rails.application.routes.draw do

  #The routes for seals is needed, do not remove!
  resources :leafs do
    resources :contracts do
      resources :seals
    end
  end

  resources :staffs
  
  get 'login' => 'login#index'
  post 'login/auth' => 'login#auth'

  get 'menu' => 'menu#index'
  post 'leafs_search' => 'leafs_search#index'
  post 'daily_contracts_report' => 'daily_contracts_report#index'
  get 'count_contracts_summary' => 'count_contracts_summary#index'

  post 'multi_seals_update' => 'multi_seals_update#index'
  post 'multi_seals_update/update' => 'multi_seals_update#update'
  #match ':controller(/:action(/:id))', via: [ :get, :post, :patch ]
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'menu#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
