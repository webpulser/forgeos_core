Forgeos::Core::Engine.routes.draw do
  match '/logout' => 'person_sessions#destroy', :as => :logout
  match '/login' => 'person_sessions#new', :as => :login
  match '/notifications' => 'application#notifications', :as => :notifications
  match '/statistics/:type/:id(.:format)' => 'statistics_collector#index', :as => :statistics_collector
  resource :person_session

  ## ADMIN ROUTES ##
  namespace :admin do
    root :to => 'dashboard#index'
    match 'dashboard' => 'dashboard#index', :as => :dashboard
    match 'dashboard/change_lang' => 'dashboard#change_lang', :as => :change_lang
    match 'logout' => 'person_sessions#destroy', :as => :logout
    match 'login' => 'person_sessions#new', :as => :login
    match '/notifications' => 'base#notifications', :as => :notifications
    match '/statistics' => 'statistics#index', :as => :statistics
    match '/statistics/graph' => 'statistics#graph', :as => :statistics_graph

    match '/import' => 'import#index', :as => :import
    match '/import/create_user' => 'import#create_user', :as => :import_create_user

    resources :tags
    resources :cachings
    resource :person_session do
      collection do
        get :reset_password
      end
    end
    resource :setting
    resource :account
    resources :administrators do
      member do
        put :activate
        get :duplicate
      end
    end

    resources :roles do
      member do
        put :activate
        get :duplicate
      end
    end
    resources :rights

    resources :users do
      collection do
        post :filter
        get :filter
        get :export_newsletter
      end
      member do
        put :activate
        get :duplicate
      end
    end

    resources :categories do
      member do
        post :add_element
      end
    end

    %w(medium picture doc pdf audio video attachment administrator role right user).each do |category|
      resources "#{category}_categories", :controller => 'categories', :type => "forgeos::#{category.capitalize}_category" do
        member do
          post :add_element
        end
      end
    end

    match '/library' => 'attachments#index', :as => :library, :klass => 'forgeos::Picture'

    resources :attachments, :controller => 'attachments'
    %w(medium picture doc pdf audio video).each do |attachment|
      resources "#{attachment.pluralize}", :controller => 'attachments', :klass => "forgeos::#{attachment.capitalize}" do
        collection do
          get :manage
        end
        member do
          get :download
        end
      end
    end
  end
  ## END ADMIN ROUTES ##
end
