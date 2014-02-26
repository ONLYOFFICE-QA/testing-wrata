Runner::Application.routes.draw do
  root :to => 'runner#index', :as => 'runner'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :clients
  get '/client_history/show_more', to: 'clients#show_more'
  get '/client_history/:id', to: 'clients#client_history', as: 'client_history'
  post '/clients/clear_history'

  resources :test_lists, only: [:index, :destroy]
  resources :history, only: :destroy
  post 'history/set_analysed'
  get '/history/show_html_results' #, as: '/history/show_html_results'

  get 'runner/index'
  get 'runner/start'
  get 'runner/start_list'
  get 'runner/show_servers'
  get 'runner/show_tests'
  get 'runner/show_subtests'
  get 'runner/load_test_list'
  get 'runner/change_branch'
  get 'runner/get_updated_data'
  get 'runner/rerun_thread'
  get 'runner/pull_projects'
  get 'runner/get_branches'
  post 'runner/stop_current'

  post 'queue/book_server'
  post 'queue/unbook_server'
  post 'queue/add_test'
  post 'queue/add_tests'
  post 'queue/delete_test'
  post 'queue/swap_tests'
  post 'queue/delete_test'
  post 'queue/change_test_location'
  post 'queue/clear_tests'
  post 'queue/retest'

  post 'runner/save_list'

  #resources :servers
  get '/server_history/show_more', to: 'servers#show_more'
  get '/servers/reboot'
  get '/servers/show_current_results'
  post '/servers/clear_history'
  get '/server_history/:id', to: 'servers#server_history' , as: 'server_history'

  resources :sessions, only: [:new, :create, :destroy]

  get '/signup',  to: 'clients#new'
  get '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
