logout '/logout', :controller => 'sessions', :action => 'destroy'
login '/login', :controller => 'sessions', :action => 'new'

resource :session

namespace :admin do |admin|
  admin.logout '/logout', :controller => 'sessions', :action => 'destroy'
  admin.login '/login', :controller => 'sessions', :action => 'new'
  admin.notifications '/notifications', :controller => 'base', :action => 'notifications'
  admin.statistics '/statistics', :controller => 'statistics'
  admin.statistics_graph '/statistics/graph', :controller => 'statistics', :action => 'graph'
 
  admin.resource :session
  admin.resources :account
  admin.resources :admins
  admin.resources :roles, :member => { :activate => :post }
  admin.resources :rights
  admin.resources :users, :collection => { :filter => [:post, :get] }, :member => { :activate => :post }

  admin.resources :categories, :member => { :add_element => :post }
  %w(picture media pdf doc video attachment admin role right user).each do |category|
    admin.resources "#{category}_categories", :controller => 'categories', :requirements => { :type => "#{category}_category" }
  end

  admin.library '/library', :controller => 'attachments', :file_type => 'picture'
  %w(medias pictures docs pdfs videos attachments role right).each do |resources_alias|
    route_options = { :controller => :attachments, :member => { :download => :get }, :except => [:new] }
    route_options[:path_prefix] = 'admin/:file_type' if %w(attachments).include?(resources_alias)
    admin.resources resources_alias.to_sym, route_options
  end

  admin.root :controller => 'dashboard'
end
