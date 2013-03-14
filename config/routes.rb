Sbase::Application.routes.draw do

  resources :sensors  do
    collection {post :import}
  end

  resources :sensor_imports, only: [:new, :create]

  resources :calibrations

  resources :calibration_imports, only: [:new, :create]

  #GET	    /users	    index	   users_path	          page to list all users
  #GET	    /users/1	  show	   user_path(user)	    page to show user
  #GET	    /users/new	new	     new_user_path	      page to make a new user
  #POST	    /users	    create	 users_path	          create a new user
  #GET	    /users/1/   edit	   edit_user_path(user)	page to edit user with id 1
  #PUT	    /users/1	  update	 user_path(user)	    update user
  #DELETE	  /users/1	  destroy	 user_path(user)	    delete user

  resources :users

  # NEW      /sessions/new   new         return an HTML form for creating a new session
  # POST	   /sessions	     create	     create a new session
  # DELETE	 /sessions/1	   destroy	   delete session with id 1

  resources :sessions, only: [:new, :create, :destroy]

  #Home	      /	         root_path
  #About	    /about	   about_path
  #Help	      /help	     help_path
  #Contact	 /contact	   contact_path
  #Sign in	 /signin	   signin_path



  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  root to: 'static_pages#home'
  match '/help',    to: 'static_pages#help'

  #match '/about',   to: 'static_pages#about'
  #match '/contact', to: 'static_pages#contact'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
