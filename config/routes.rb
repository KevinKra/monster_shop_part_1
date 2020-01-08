Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	get "/", to: "welcome#index"

	namespace :merchants do
		get "/dashboard", to: 'dashboard#show'
	end

	namespace :admin do
		get "/dashboard", to: 'dashboard#show'
		get "/merchants", to: 'merchants#index'
		get "/merchants/:id", to: 'merchants#show'
		get "/merchants/:id/edit", to: 'merchants#edit'
		patch "/merchants/:id", to: 'merchants#update'
	end

	get '/dashboard/items', to: "items#index"

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

  get "/cart", to: "cart#show"
	patch "/cart/:item_id/:quantity", to: "cart#edit_quantity"
	post "/cart/:item_id", to: "cart#add_item"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  get "/orders/new", to: "orders#new"
  get "/orders/:id", to: "orders#show"
	patch "/orders/:id/:status", to: "orders#update"
	get "/profile/orders", to: 'orders#index'
	get "/profile/orders/:id", to: "orders#show"
	patch "/profile/orders/:id", to: "orders#update"
	post "/profile/orders", to: "orders#create"

	get "/register", to: 'users#new'
	get "/users", to: 'users#index'
	resources :users, only: [:edit, :update]
  get "/profile", to: 'users#show'
  post "/register", to: 'users#create'
  get "/profile/edit_password", to: 'users#edit_password'

  patch "/profile", to: 'users#update_password'

	get '/login', to: 'sessions#new'
	post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

	namespace :merchant do
		post '/items/new', to: 'items#create'
		resources :items, only: [:index, :update, :destroy, :new, :edit]
	end

  get '/welcome/home', to: 'welcome#index'
	# via: :all includes all Restful verbs
	match '*path' => 'errors#show', via: :all
end
