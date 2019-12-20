Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	get "/", to: "welcome#index"

	namespace :merchants do
		get "/dashboard", to: 'dashboard#show'
	end

	namespace :admin do
		get "/dashboard", to: 'dashboard#show'
	end

	namespace :users do
		get "/profile", to: 'profile#show'
	end

  get "/merchants", to: "merchants#index"
  get "/merchants/new", to: "merchants#new"
  get "/merchants/:id", to: "merchants#show"
  post "/merchants", to: "merchants#create"
  get "/merchants/:id/edit", to: "merchants#edit"
  patch "/merchants/:id", to: "merchants#update"
  delete "/merchants/:id", to: "merchants#destroy"

  get "/items", to: "items#index"
  get "/items/:id", to: "items#show"
  get "/items/:id/edit", to: "items#edit"
  patch "/items/:id", to: "items#update"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  delete "/items/:id", to: "items#destroy"

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  get "/reviews/:id/edit", to: "reviews#edit"
  patch "/reviews/:id", to: "reviews#update"
  delete "/reviews/:id", to: "reviews#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  get "/orders/new", to: "orders#new"
  post "/orders", to: "orders#create"
  get "/orders/:id", to: "orders#show"

	get "/users", to: 'users#index'
	get "/register", to: 'users#new'
	get "/users/:id/edit", to: 'users#edit'######## Made this one
	# patch "/users/:id", to: 'users#update'######## Made this one
	# patch "/users/:id", as: :user, to: 'users#update'######## or add this one too
	resources :users, only:[:update]
	# get "/users/profile", to: 'users#show'
	post "/register", to: 'users#create'

	get '/login', to: 'sessions#new'
	post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'


  get '/welcome/home', to: 'welcome#index'
	# via: :all includes all Restful verbs
	match '*path' => 'errors#show', via: :all
end
