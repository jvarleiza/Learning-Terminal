Rails.application.routes.draw do
  root 'index#index'

  resources :tasks
  resources :quality_tips
  resources :process_lts
  resources :roles
  resources :bookmarks
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  
  get '/info', to: 'info#info'
  get '/dev', to: 'info#dev'
  get '/test', to: 'info#test'
  get '/search', to: 'search#search_results'
  get '/not_allowed', to: 'errors#not_allowed'
  
  #data listing
  get '/listing/:type', to: 'index#listing'
  get '/group', to: 'index#group'
  
  # Admin routes
  get '/tasks_admin', to: 'tasks#index_admin'
  get '/process_lts_admin', to: 'process_lts#index_admin'
  get '/roles_admin', to: 'roles#index_admin'
  get '/quality_tips_admin', to: 'quality_tips#index_admin'
  
  # Form data routes
  get '/roles_form', to: 'roles#index_form'
  get '/processes_form', to: 'process_lts#index_form'
  get '/tasks_form', to: 'tasks#index_form'
  
  # -- START: include content in other language --
  get '/roles/duplicate/:id/:locale', to: 'roles#duplicate'
  post '/roles/duplicate', to: 'roles#duplicate_create'
  
  get '/process_lts/duplicate/:id/:locale', to: 'process_lts#duplicate'
  post '/process_lts/duplicate', to: 'process_lts#duplicate_create'
  
  get '/tasks/duplicate/:id/:locale', to: 'tasks#duplicate'
  post '/tasks/duplicate', to: 'tasks#duplicate_create'
  # -- END: Duplicate content --

  # Level 7 health check
  match '/ping', to: 'ping#ping', via: :all
  match '/sping', to: 'ping#ping', via: :all

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

  # This is a catch all error page for 404s that avoids logging FATAL messages
  # unless the referer is local.  We place this here so that Rails Engines and
  # other gems can provide glob routes.
  # NOTE: THIS MUST BE THE LAST LINE IN YOUR ROUTES BLOCK!
  match '*a', to: 'errors#routing', via: :all
end
