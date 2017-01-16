Rails.application.routes.draw do
  resources :photos
	root to: "home#index"
  devise_for :users, controllers: { registrations: "users/registrations" }
  
end
