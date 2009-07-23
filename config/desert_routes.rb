namespace :admin do |admin|
  admin.logout '/logout', :controller => 'sessions', :action => 'destroy'
  admin.login '/login', :controller => 'sessions', :action => 'new'

  admin.resource :session
  admin.resources :account
  admin.resources :admins
  admin.resources :roles
  admin.resources :rights
  admin.root :controller => 'account'
end
