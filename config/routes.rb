Rails.application.routes.draw do
  root to: 'runner#index', as: 'runner'

  resources :clients
  get '/servers/show_current_results' # should always be on top of `resources :servers` for correctly shown current status
  get '/servers/cloud_server_fetch_ip'
  resources :servers
  resources :test_files
  resources :test_lists
  get '/histories/show_html_results' # should always be on top of `resources :histories` for server_history rspec-result correctly shown
  get '/histories/log_file' # should always be on top of `resources :histories` for server_history rspec-result correctly shown
  resources :histories
  get '/client_history/show_more', to: 'clients#show_more'
  get '/client_history/:id', to: 'clients#client_history', as: 'client_history'
  post '/clients/clear_history'
  post '/servers/cloud_server_create'
  post '/servers/cloud_server_destroy'

  get 'runner/index'
  get 'runner/start'
  get 'runner/start_list'
  get 'runner/show_servers'
  get 'runner/show_tests'
  get 'runner/show_subtests'
  get 'runner/load_test_list'
  get 'runner/change_branch'
  get 'runner/updated_data'
  get 'runner/rerun_thread'
  get 'runner/pull_projects'
  get 'runner/branches'
  post 'runner/stop_current'
  post 'runner/stop_all_booked'
  post 'runner/destroy_all_unbooked_servers'

  post 'queue/book_server'
  post 'queue/unbook_server'
  post 'queue/unbook_all_servers'
  post 'queue/add_test'
  post 'queue/add_tests'
  post 'queue/delete_test'
  post 'queue/remove_duplicates'
  post 'queue/shuffle_tests'
  post 'queue/swap_tests'
  post 'queue/delete_test'
  post 'queue/change_test_location'
  post 'queue/clear_tests'
  post 'queue/retest'

  get 'delay_run', to: 'delay_run#index', as: 'delay_run'
  get 'delay_run/add_delayed_row'
  post 'delay_run/add_run'
  post 'delay_run/change_run'
  post 'delay_run/delete_run'

  post 'runner/save_list'

  get '/server_history/show_more', to: 'servers#show_more'
  get '/server_history/:id', to: 'servers#server_history', as: 'server_history'
  post '/servers/destroy'
  post '/servers/create'
  post '/servers/clear_history'

  resources :sessions, only: [:new, :create, :destroy]

  get '/signup',  to: 'clients#new'
  get '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  get 'empty_pages/empty_test_list', as: 'empty_test_list'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
