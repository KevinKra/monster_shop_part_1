Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	get "/", to: "welcome#index"

	namespace :merchants do
		get "/dashboard", to: 'dashboard#show'
	end

	namespace :admin do
		get "/dashboard", to: 'dashboard#show'
	end
	resources :merchants   #installed by Alex on Saturday 12/21

	resources :items #installed by Alex on Saturday 12/21

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


  get '/welcome/home', to: 'welcome#index'
	match '*path' => 'errors#show', via: :all    	# via: :all includes all Restful verbs

end
