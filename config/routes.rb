ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'person_sessions', :action => 'destroy'
  map.login '/login', :controller => 'person_sessions', :action => 'new'

  map.resource :person_session

  map.namespace :admin do |admin|
    admin.logout 'logout', :controller => 'person_sessions', :action => 'destroy'
    admin.login 'login', :controller => 'person_sessions', :action => 'new'
    admin.notifications '/notifications', :controller => 'base', :action => 'notifications'
    admin.statistics '/statistics', :controller => 'statistics'
    admin.statistics_graph '/statistics/graph', :controller => 'statistics', :action => 'graph'
   
    admin.resource :person_session
    admin.resource :setting
    admin.resource :account
    admin.resources :administrators, :member => { :activate => :post }
    admin.import '/import', :controller => 'import'
    admin.resources :roles, :member => { :activate => :post }
    admin.resources :rights
    admin.resources :users, :collection => { :filter => [:post, :get] }, :member => { :activate => :post }
    admin.resources :menus, :member => { :activate => :post, :duplicate => :get }

    admin.resources :categories, :member => { :add_element => :post }
    %w(picture media pdf doc audio video attachment admin role right user menu).each do |category|
      admin.resources "#{category}_categories", :controller => 'categories', :requirements => { :type => "#{category}_category" }
    end

    admin.library '/library', :controller => 'attachments', :file_type => 'picture'
    %w(medias pictures docs pdfs audios videos attachments).each do |resources_alias|
      route_options = { :controller => :attachments, :collection => { :manage => :get }, :member => { :download => :get }, :except => [:new] }
      route_options[:path_prefix] = 'admin/:file_type' if %w(attachments).include?(resources_alias)
      admin.resources resources_alias.to_sym, route_options
    end

    admin.root :controller => 'dashboard'
  end
end
