namespace :admin do |admin|
  admin.logout '/logout', :controller => 'sessions', :action => 'destroy'
  admin.login '/login', :controller => 'sessions', :action => 'new'
  admin.notifications '/notifications', :controller => 'base', :action => 'notifications'

#  admin.connect 'medias/:file_type', :controller => :medias, :action => :index
#  admin.connect 'medias/:file_type/new', :controller => :medias, :action => :new
  
  admin.resource :session
  admin.resources :account
  admin.resources :admins
  admin.resources :roles, :member => { :activate => :post }
  admin.resources :rights
  %w(medias pictures docs pdfs videos attachments).each do |resources_alias|
    route_options = { :controller => :attachments, :member => { :download => :get } }
    route_options[:path_prefix] = 'admin/:file_type' if %w(attachments).include?(resources_alias)
    admin.resources resources_alias.to_sym, route_options
  end
  admin.root :controller => 'dashboard'
end
