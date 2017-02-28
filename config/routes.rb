Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
	get 'profile/show/', to: 'profile#show', as: 'profile_show'
	get 'profile/other_user_show/:id', to: 'profile#other_user_show', as: 'profile_other_user_show'
	get 'import_facebook/photos/', to: 'import_photos#import_facebook', as: 'import_facebook'
	get 'import_instagram/photos/', to: 'import_photos#import_instagram', as: 'import_instagram'
	get 'import_google/photos/', to: 'import_photos#import_google', as: 'import_google'

	post "/photos/create_import_instagram", to: 'photos#create_import_instagram', as: :create_import_instagram
	post "/photos/create_import_facebook", to: 'photos#create_import_facebook', as: :create_import_facebook
	post "users/lock/:id", to: 'user_locks#lock_access', as: :lock_access
	get 'photos/load_photo_to_sort', as: 'load_new_photo_to_sort'
	get 'photos/reaload_photos_queue'
	patch 'photos/update_photo_to_sorted_state'
  post 'photos/create_sections'
  post 'photos/create_sortings'
  post 'photos/info_sorting'
  get 'photos/load_sorting_stats'
  patch "users/create_role/:id", to: 'users#create_reviewer_role', as: :create_reviewer_role
  patch "users/remove_role/:id", to: 'users#remove_reviewer_role', as: :remove_reviewer_role
  patch "users/suspend_account/:id", to: 'users#suspend_account', as: :suspend_account
  patch "users/active_account/:id", to: 'users#active_account', as: :active_account
  get :followers, to: "relationships#followers"
  get :following, to: "relationships#following"
  patch "photos/suspend_photo/:id", to: 'photos#suspend', as: :suspend
  patch "photos/approve_photo/:id", to: 'photos#approve', as: :approve
  
  resources :photos do
  	member do
      patch :shared_times
    	get "like", to: "photos#like"
      get "unlike", to: "photos#unlike"
    end
	end
	root to: "home#index"
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: "users/registrations" }
  resources :after_signup
  resources :charges

  resources :relationships, only: [:create, :destroy]
  resources :flags, only: [:create]
  resources :justifications, only: [:create, :destroy, :new]

end
