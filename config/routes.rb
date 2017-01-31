Rails.application.routes.draw do

	get 'profile/show/', to: 'profile#show', as: 'profile_show'
	get 'import_facebook/photos/', to: 'import_photos#import_facebook', as: 'import_facebook'
	get 'import_instagram/photos/', to: 'import_photos#import_instagram', as: 'import_instagram'
	post "/photos/create_import_instagram", to: 'photos#create_import_instagram', as: :create_import_instagram
	post "/photos/create_import_facebook", to: 'photos#create_import_facebook', as: :create_import_facebook
	post "users/lock/:id", to: 'user_locks#lock_access', as: :lock_access

  resources :photos do
  	member do
      patch :shared_times
    end
	end
	root to: "home#index"
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: "users/registrations" }
  resources :after_signup
  resources :charges
end
