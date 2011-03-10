module Forgeos
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
        { :controller => 'admin/audio/attachments' },
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
end
