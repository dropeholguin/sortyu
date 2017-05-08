Rails.application.routes.draw do
  
  get 'pages/privacy'

  get 'pages/terms_and_conditions'

  devise_for :affiliates, controllers: { registrations: "users/registrations" }

  devise_for :admin_reviewers, ActiveAdmin::Devise.config.merge({path: '/reviewer'})
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get 'affiliates', to: 'home#affiliate', as: 'affiliate_home'
  
	get 'profile/show/', to: 'profile#show', as: 'profile_show'
	get 'profile/other_user_show/:id', to: 'profile#other_user_show', as: 'profile_other_user_show'
  get 'profile/affiliate/:id', to: 'profile#affiliate', as: 'profile_affiliate_show'

	get 'import_facebook/photos/', to: 'import_photos#import_facebook', as: 'import_facebook'
	get 'import_instagram/photos/', to: 'import_photos#import_instagram', as: 'import_instagram'
	get 'import_google/photos/', to: 'import_photos#import_google', as: 'import_google'

	post "/photos/create_import_instagram", to: 'photos#create_import_instagram', as: :create_import_instagram
	post "/photos/create_import_facebook", to: 'photos#create_import_facebook', as: :create_import_facebook
	post "users/lock/:id", to: 'user_locks#lock_access', as: :lock_access
  patch "users/hide_results"
	get 'photos/load_photo_to_sort', as: 'load_new_photo_to_sort'
	get 'photos/reaload_photos_queue'
  get 'photos/remove_photos', to: 'photos#remove_photos', as: 'remove_photos'
  get 'photos/pay_photos', to: 'photos#pay_multiple_photos', as: 'pay_multiple_photos'
  get 'photos/load_sections_to_sort'
  get 'photo/edit_sections', to:'photos#edit_sections'
  get 'photos/load_sections_tracker'
  post 'photos/save_sections', to: 'photos#save_sections'
	patch 'photos/update_photo_to_sorted_state'
  post 'photos/create_sections'
  post 'photos/create_sortings'
  post 'photos/info_sorting'
  get 'photos/load_sorting_stats'
  get 'photos/recent_sorts', to: 'photos#recent_sorts', as: 'recent_sorts'
  patch "users/create_role/:id", to: 'users#create_reviewer_role', as: :create_reviewer_role
  patch "users/remove_role/:id", to: 'users#remove_reviewer_role', as: :remove_reviewer_role
  patch "users/suspend_account/:id", to: 'users#suspend_account', as: :suspend_account
  patch "users/active_account/:id", to: 'users#active_account', as: :active_account
  patch "suspend_account_affiliate/:id", to: 'users#suspend_account_affiliate', as: :suspend_account_affiliate
  patch "active_account_affiliate/:id", to: 'users#active_account_affiliate', as: :active_account_affiliate
  get :followers, to: "relationships#followers"
  get :following, to: "relationships#following"
  patch "photos/suspend_photo/:id", to: 'photos#suspend', as: :suspend
  patch "photos/approve_photo/:id", to: 'photos#approve', as: :approve
  delete "destroy_photos", to: 'photos#destroy_photos'
  post "edit_photos", to: 'photos#edit_photos'
  post "pay_photos", to: 'photos#pay_photos'
  get "invite_sort_friend/:id", to: 'photos#sort_friend', as: :sort_friend
  post "photos/upload_process", to: 'photos#upload_process'
  post "photos/upload_photos", to: 'photos#upload_photos'
  get 'photos/pay_upload_process',to: 'photos#pay_upload_process', as: 'pay_upload_process'
  get 'photos/select_photos',to: 'photos#select_photos', as: 'select_photos'


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
