Rails.application.routes.draw do
  match '/logout' => 'person_sessions#destroy', :as => :logout
  match '/login' => 'person_sessions#new', :as => :login
  match '/notifications' => 'application#notifications', :as => :notifications
  match '/statistics/:type/:id.:format' => 'statistics_collector#index', :as => :statistics_collector

  ## ADMIN ROUTES ##
  namespace :admin do
    match 'logout' => 'person_sessions#destroy', :as => :logout
    match 'login' => 'person_sessions#new', :as => :login
    match '/notifications' => 'base#notifications', :as => :notifications
    match '/statistics' => 'statistics#index', :as => :statistics
    match '/statistics/graph' => 'statistics#graph', :as => :statistics_graph
    resources :cachings
    resource :person_session
    resource :setting
    resource :account
    resources :administrators do
    
      member do
        post :activate
      end
    
    end
    match '/import' => 'import#index', :as => :import
    resources :roles do
      member do
        post :activate
      end
    end
    resources :rights
    resources :users do
      collection do
        post :filter
        get :filter
      end
      member do
        post :activate
      end
    end
    resources :menus do
      member do
        get :duplicate
        post :activate
      end
    end
    resources :categories do
      member do
        post :add_element
      end
    end
    resources :picture_categories
    resources :media_categories
    resources :pdf_categories
    resources :doc_categories
    resources :audio_categories
    resources :video_categories
    resources :attachment_categories
    resources :admin_categories
    resources :role_categories
    resources :right_categories
    resources :user_categories
    resources :menu_categories
    match '/library' => 'attachments#index', :as => :library, :file_type => 'picture'
    resources :medias, :except => [:new] do
      collection do
        get :manage
      end
      member do
        get :download
      end
    
    end
    resources :pictures, :except => [:new] do
      collection do
        get :manage
      end
      member do
        get :download
      end
    end
    resources :docs, :except => [:new] do
      collection do
        get :manage
      end
      member do
        get :download
      end
    end
    resources :pdfs, :except => [:new] do
      collection do
        get :manage
      end
      member do
        get :download
      end
    end
    resources :audios, :except => [:new] do
      collection do
        get :manage
      end
      member do
        get :download
      end
    end
    resources :videos, :except => [:new] do
      collection do
        get :manage
      end
      member do
        get :download
      end
    end
    resources :attachments, :except => [:new] do
      collection do
        get :manage
      end
      member do
        get :download
      end
    end
  end
  
  root :to => 'person_sessions#new'

  ## END ADMIN ROUTES ##
end
