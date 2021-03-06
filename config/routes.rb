require 'sub_domain'

Rails.application.routes.draw do

  constraints(subdomain: /^(www)?$/i) do
    root 'static_pages#home'
    get 'password_resets/new'
    get 'password_resets/edit'
    get 'help' => 'static_pages#help'
    get 'about' => 'static_pages#about'
    get 'contact' => 'static_pages#contact'
    get 'signup' => 'users#new'
    get 'login' => 'sessions#new'
    post 'login' => 'sessions#create'
    delete 'logout' => 'sessions#destroy'
    resources :users do
      member do
        get :following, :followers, :schedules
        post :schedules
        patch :basic_setting, :password_setting, :blog_setting
      end
    end

    resources :account_activations, only: [:edit]
    resources :password_resets, only: [:new, :create, :edit, :update]
    resources :microposts, only: [:create, :destroy]
    resources :relationships, only: [:create, :destroy]
    resources :schedules, only: [:new, :create, :destroy, :update] do
      member do
        post :complete, :uncomplete
      end
    end
  end

  constraints(SubDomain) do
    namespace :blog do
      root 'posts#index'
      get '/page/:page', to:  'posts#index', as:  'posts_page'
      get '/feed' => 'posts#feed', as:  'feed', defaults: {format: :rss}

      get '/tags/:tag' =>'tags#show', as: 'tags_page'

      resources :posts , only: [] do
        resources :comments, only: [:create, :destroy]
      end
      #post '/:post_id/comments' => 'comments#create'
      #delete '/:post_id/comment/:comment_id' => 'comments#delete'

      namespace :admin do
        get '/' => 'posts#index', as:  '' # responds to admin_url and admin_path
        get '/page/:page', to:  'posts#index', as:  'posts_page'
        resources :posts
        get 'comments' => 'comments#show', as: 'comments'

        match '/posts/markdown_prev' => 'posts#markdown_prev', :as=>'post_markdown_prev', :via => [:put, :post]
        match '/post/preview'=>'posts#preview', :as=>'post_preview', :via => [:put, :post]
      end

      get '*post_url' => 'posts#show', as:  'post'
    end
  end

  mount Markitup::Rails::Engine, at: 'markitup', as: 'markitup'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
