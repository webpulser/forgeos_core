namespace :admin do |admin|
  admin.logout '/logout', :controller => 'sessions', :action => 'destroy'
  admin.login '/login', :controller => 'sessions', :action => 'new'
  admin.notifications '/notifications', :controller => 'base', :action => 'notifications'
  admin.statistics '/statistics', :controller => 'statistics'

#  admin.connect 'medias/:file_type', :controller => :medias, :action => :index
#  admin.connect 'medias/:file_type/new', :controller => :medias, :action => :new
  
  admin.resource :session
  admin.resources :account
  admin.resources :admins
  admin.resources :roles, :member => { :activate => :post }
  admin.resources :rights
  %w(medias pictures docs pdfs videos attachments).each do |resources_alias|
    route_options = { :controller => :attachments, :member => { :download => :get }, :except => [:new] }
    route_options[:path_prefix] = 'admin/:file_type' if %w(attachments).include?(resources_alias)
    admin.resources resources_alias.to_sym, route_options
  end
  %w(picture media pdf doc video attachment admin role right).each do |category|
    admin.resources "#{category}_categories", :controller => 'categories', :requirements => { :type => "#{category}_category" }
  end
  admin.library '/library', :controller => 'attachments', :file_type => 'picture'
  admin.root :controller => 'dashboard'
end
