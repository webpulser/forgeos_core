Dummy::Application.routes.draw do
  root :to => 'forgeos/person_sessions#new'
  match 'directory/:id' => 'directory#show', :as => 'current_path_detection'
  match 'keep_flash_test' => 'forgeos/application#keep_flash_test'
  match 'login_required_test' => 'forgeos/application#login_required_test'
  match 'forgeos/admin/login_required_test' => 'forgeos/admin/base#login_required_test'
  match 'forgeos/admin/edition_locale_test' => 'forgeos/admin/base#edition_locale_test'
  mount Forgeos::Core::Engine => '/', :as => 'forgeos_core'
end
