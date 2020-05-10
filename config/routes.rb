Rails.application.routes.draw do
  #devise_for :users
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :posts do
    get :top, :fresh, on: :collection
    member do
      put "like", to: "posts#like"
    end
  end

  root 'posts#top'
  get 'static_pages/index'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
