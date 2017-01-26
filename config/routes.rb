Rails.application.routes.draw do

	get 'profile/show/', to: 'profile#show', as: 'profile_show'
  resources :photos
	root to: "home#index"
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: "users/registrations" }
  resources :after_signup
  resources :charges
end
