Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
        namespace :admin do
        namespace :auth do
          resources :sessions, only: :create do
            post :refresh, on: :collection
            delete :logout, on: :collection, action: :destroy
          end
          resource :registration, only: [:show, :update]
        end
        resources :subscribers, only: [:index, :destroy] do
          collection do
            post 'export'
          end
        end
        resources :inquiries, except: :create
        resources :travel_packages
        resources :promos
        resource :user, controller: "user", only: [ :show, :update ]
        resources :users, only: [:index, :create, :update, :destroy]
        resources :analytics, only: :index
      end
      scope module: :client do
        resources :travel_packages, only: [:index, :show] do
          post 'inquire', on: :member
        end
        resources :subscribers, only: [:create] do
          collection do
            get 'unsubscribe/:token', to: 'subscribers#unsubscribe', as: :unsubscribe
          end
        end
        resources :inquiries, only: [:create]
        resources :promos, only: [:index, :show]
      end
    end
  end
end
