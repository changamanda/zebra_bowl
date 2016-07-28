Rails.application.routes.draw do
  resources :games, only: [:index, :create, :show] do
    resources :players, only: [:create, :update]
  end
  root 'games#index'
end
