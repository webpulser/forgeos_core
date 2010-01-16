# encoding: utf-8
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

  AdminSubMenu = [
    { :title => 'back_office.menu.administration',
      :i18n => true,
      :url => [
        { :controller => 'admin/administrators' },
        { :controller => 'admin/roles' },
        { :controller => 'admin/rights' }
      ],
      :html => { :class => 'left first'}
    },
    { :title => 'back_office.menu.settings',
      :i18n => true,
      :url => { :controller => 'admin/setting'},
      :html => { :class => 'left' }
    },
    { :title => 'back_office.menu.library',
      :i18n => true,
      :url => [
        { :controller => 'admin/library' },
        { :controller => 'admin/images/attachments' },
        { :controller => 'admin/pdf/attachments' },
        { :controller => 'admin/video/attachments' },
        { :controller => 'admin/media/attachments' },
        { :controller => 'admin/doc/attachments' }
      ],
      :html => { :class => 'left' }
    },
    { :title => 'back_office.menu.accounts',
      :i18n => true,
      :url => { :controller => 'admin/account' },
      :html => { :class => 'left' }
    },
    { :title => 'back_office.menu.logout',
      :i18n => true,
      :url => { :controller => 'admin/logout' },
      :html => { :class => 'right' }
    },
    { :title => 'back_office.menu.support',
      :i18n => true,
      :url => 'http://www.webpulser.com',
      :html => { :class => 'right first' }
    }
    #{ :title => 'see_site',
    #  :i18n => true,
    #  :url => :root,
    #  :html => { :class => 'right first' }
    #}
  ]
  
  # Set site's menu
  Menu = []
end
