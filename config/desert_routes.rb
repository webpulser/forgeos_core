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
  admin.resources :medias, :except => [:edit], :member => { :download => :get, :sort => :post }, :path_prefix => 'admin/:file_type'
  admin.resources :attachments, :controller => :medias, :except => [:edit], :member => { :download => :get, :sort => :post }
#  admin.root :controller => 'account'
  admin.root :controller => 'products'
end
