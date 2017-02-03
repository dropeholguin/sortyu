Rails.application.routes.draw do

	get 'profile/show/', to: 'profile#show', as: 'profile_show'
	get 'import_facebook/photos/', to: 'import_photos#import_facebook', as: 'import_facebook'
	get 'import_instagram/photos/', to: 'import_photos#import_instagram', as: 'import_instagram'
	get 'import_google/photos/', to: 'import_photos#import_google', as: 'import_google'

	post "/photos/create_import_instagram", to: 'photos#create_import_instagram', as: :create_import_instagram
	post "/photos/create_import_facebook", to: 'photos#create_import_facebook', as: :create_import_facebook
	post "users/lock/:id", to: 'user_locks#lock_access', as: :lock_access
	get 'photos/load_photo_to_sort', as: 'load_new_photo_to_sort'
	get 'photos/reaload_photos_queue'
	patch 'photos/update_photo_to_sorted_state'

  resources :photos do
  	member do
      patch :shared_times
    	put "like", to: "photos#like"
      put "unlike", to: "photos#unlike"
    end
	end
	root to: "home#index"
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: "users/registrations" }
  resources :after_signup
  resources :charges

  resources :relationships, only: [:create, :destroy]
end
