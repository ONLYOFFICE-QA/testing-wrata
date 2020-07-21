# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :projects
  resources :spec_browsers
  resources :spec_languages
  root to: 'runner#index', as: 'runner'

  get '/clients/api_keys'
  resources :clients
  # should always be on top of `resources :servers`
  # for correctly shown current status
  get '/servers/show_current_results'
  get '/servers/cloud_server_fetch_ip'
  get '/servers/log'
  get '/servers/create_multiple' => 'servers#create_multiple'
  post '/servers/create_multiple' => 'servers#create_servers_multiple'
  resources :servers
  resources :test_files
  resources :test_lists
  # should always be on top of `resources :histories`
  # for server_history rspec-result correctly shown
  get '/histories/show_html_results'
  # should always be on top of `resources :histories`
  # for server_history rspec-result correctly shown
  get '/histories/log_file'
  resources :histories
  get '/client_history/show_more', to: 'clients#show_more'
  get '/client_history/:id', to: 'clients#client_history', as: 'client_history'
  post '/clients/clear_history'
  post '/servers/cloud_server_create'
  post '/servers/cloud_server_destroy'

  get 'runner/index'
  get 'runner/show_servers'
  get 'runner/show_tests'
  get 'runner/load_test_list'
  get 'runner/updated_data'
  get 'runner/rerun_thread'
  get 'runner/branches'
  get 'runner/file_tree'
  post 'runner/stop_current'
  post 'runner/stop_all_booked'
  post 'runner/destroy_all_unbooked_servers'

  post 'queue/book_server'
  post 'queue/unbook_server'
  post 'queue/unbook_all_servers'
  post 'queue/add_test'
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

  resources :sessions, only: %i[new create destroy]

  get '/signup',  to: 'clients#new'
  get '/signin',  to: 'sessions#new'
  delete '/signout', to: 'sessions#destroy'

  get 'empty_pages/empty_test_list', as: 'empty_test_list'
end
