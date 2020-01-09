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
		get "/users", to: 'users#index'
		get "/users/:id", to: 'users#profile'
	end

	get '/dashboard/items', to: "items#index"

	resources :merchants

	resources :items, only: [:index, :show, :edit, :update, :destroy]

  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

	resources :reviews, only: [:edit, :update, :destroy]

  get "/cart", to: "cart#show"
	patch "/cart/:item_id/:quantity", to: "cart#edit_quantity"
	post "/cart/:item_id", to: "cart#add_item"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

	resources :orders, only: [:new, :show]

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
