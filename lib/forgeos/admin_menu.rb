module Forgeos
  # Set administration's menu
  AdminMenu = [
    { :title => 'back_office.menu.dashboard',
      :url => { :controller => 'admin/dashboard' },
      :i18n => true,
      :html => { :class => 'left'}
    },
    { :title => 'back_office.menu.users',
      :url => { :controller => 'admin/users' }, 
      :i18n => true,
      :html => { :class => 'left'}
    },
    { :title => 'back_office.menu.statistics',
      :url => { :controller => 'admin/statistics' },
      :i18n => true,
      :html => { :class => 'right' }
    }
  ]
end
