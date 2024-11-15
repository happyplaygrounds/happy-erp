Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  #
  #  devise_for :users
    devise_for :users, path_names: {
                sign_up: '' #Stop Sign Up
        }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

        #root to: "happy_orders#index"
        root to: "happy_customers#index"

        resources :happy_customers do
          resources :happy_quotes, :happy_orders
        end


        resources :happy_quotes do
          resources :happy_quote_lines
          patch :move
          get 'po'
          get 'pwfreight'
          get 'pocreate'
          get 'poview'
          get 'copy'
          get 'createsub'
          get 'sortlines'
        end

        resources :happy_pos do
          resources :happy_po_lines
          get 'finalize'
          get 'poprint'
        end

        #resources :happy_orders do
          #resources :happy_order_lines
        #end

        resources :happy_projects do
          resources :happy_project_tasks
              get 'loadprocess'
          match :add, via: [:get, :post]
        end

        resources :happy_standard_tasks do
           resources :happy_standard_activities
        end

        resources :happy_standard_processes

        resources :happy_reminders do
          collection do
            get :edit_multiple
            put :update_multiple
          end
        end

        resources :happy_project_members
        resources :happy_project_teams

        #resources :happy_standard_tasks
        #resources :happy_standard_processes
        #resources :happy_standard_activities

        resources :happy_vendors

        resources :happy_install_sites do
          get 'customer_select'
        end

        get '/happy_products/productinfo', action: :productinfo,  controller: 'happy_products'
        resources :happy_products
end
