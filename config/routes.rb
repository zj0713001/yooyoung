Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'main/devise/registrations',
    sessions: 'main/devise/sessions',
    passwords: 'main/devise/passwords',
  }
  devise_scope :user do
    get 'users/send_sms_captcha' => 'main/devise/registrations#send_sms_captcha', as: :users_send_sms_captcha
    post 'users/check_phone' => 'main/devise/registrations#check_phone', as: :users_check_phone
  end

  %w(404 422 500 503).each do |code|
    match code, to: "application#errors", via: :all, code: code
  end

  scope module: :main do
    root 'home#index'
    get 'my' => 'trades#index', as: :my
    resources :hotels, only: [:index, :show]
    scope :about, module: :about do
      get :yooyoung
      get :business
      get :unique
      get :protocols
    end
    resources :trades, except: [:edit] do
      resources :payments, path: :pay, only: [:new] do
        member do
          get :notify
          post :notify
          get :done
          post :done
        end
      end
      member do
        get :pay_success
      end
    end
    resources :prices, only: [:index] do
      member do
        get :package_min_price
      end
    end

    namespace :mobile do
      root 'home#index'
      get 'my' => 'trades#index', as: :my
      resources :hotels, only: [:index, :show]
      scope :about, module: :about do
        # get :yooyoung
        # get :business
        get :unique
        # get :protocols
      end
      resources :trades, except: [:edit] do
        member do
          get :pay_success
          # get :pay
        end
        collection do
          get :calendar
        end
        # resources :payments, path: :pay, only: [] do
        #   member do
        #     get :done
        #     post :done
        #   end
        # end
      end
      devise_for :users, skip: [:sessions, :registrations, :passwords]

      resources :sessions, only: [:new], path: :users, controller: 'devise/sessions' do
        get :new, path: :sign_in, as: :new, on: :collection
      end
      resources :registrations, only: [:new], path: :users, controller: 'devise/registrations' do
        get :new, path: :sign_up, as: :new, on: :collection
      end
    end
  end

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
  namespace :admin do
    concern :deletable do
      get :delete, on: :member
    end
    # Directs /admin/products/* to Admin::ProductsController
    # (app/controllers/admin/products_controller.rb)
    root 'hotels#index'
    resources :users, only: [:index, :show, :edit, :update] do
      collection do
        get :links
        get :agents
      end
    end
    resources :photos, only: [:create, :update, :destroy]
    resources :roles, concerns: :deletable
    resources :areas, concerns: :deletable
    resources :categories, concerns: :deletable
    resources :cities, concerns: :deletable
    resources :countries, concerns: :deletable
    resources :hotels, concerns: :deletable do
      resources :rooms, except: [:index], concerns: :deletable
      resources :hotel_packages, except: [:index], concerns: :deletable
    end
    resources :links
    resources :provinces, concerns: :deletable
    resources :prices, only: [:show, :index, :create]
    resources :trades, only: [:show, :index, :edit, :update]
  end
end
