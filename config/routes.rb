Rails.application.routes.draw do
<<<<<<< Updated upstream
  devise_for :users, controllers: {
      sessions: 'users/sessions'
=======
  resources :tasks
  resources :lists
  get 'home/index'

  delete '/listsubscribers/:id', to: 'list_subscribers#delete', :as => 'remove_user_subscription'
  post '/listsubscribers', to: 'list_subscribers#create', :as => 'add_user_subscription'

  devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
>>>>>>> Stashed changes
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "home#index"
<<<<<<< Updated upstream
=======
  mount ActionCable.server => '/cable'

>>>>>>> Stashed changes
end
