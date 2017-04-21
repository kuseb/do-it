Rails.application.routes.draw do
  resources :tasks, :except => [:edit, :show, :all, :new]
  resources :lists, :except => [:all, :new] do
    member do
      get 'show_with_edit' => 'lists#show_with_edit'
    end
  end

  get 'home/index'

  delete '/listsubscribers/:id', to: 'list_subscribers#delete', :as => 'remove_user_subscription'
  post '/listsubscribers', to: 'list_subscribers#create', :as => 'add_user_subscription'

  devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "home#index"

  mount ActionCable.server => '/cable'

end
