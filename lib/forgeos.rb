module Forgeos
  # Set administration's menu
  AdminMenu = [
    { :title => 'admins', :url => { :controller => 'admin/admins' }, :i18n => true,
      :children => [
        { :title => 'rights', :url => { :controller => 'admin/rights' }, :i18n => true },
        { :title => 'roles', :url => { :controller => 'admin/roles' }, :i18n => true }
      ]
    },
    { :title => 'medias', :url => { :controller => 'admin/medias' }, :i18n => true }
  ]
  # Set site's menu
  Menu = []
end
