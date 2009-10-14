# coding: utf-8
require 'action_view/helpers/assert_tag_helper'
module Forgeos
  # Set administration's menu
  AdminMenu = [
    { :title => 'dashboard',
      :url => { :controller => 'admin/dashboard' },
      :i18n => true,
      :html => { :class => 'left'}
    },
    { :title => 'users',
      :url => { :controller => 'admin/users' }, 
      :i18n => true,
      :html => { :class => 'left'}
    },
    { :title => 'statistics',
      :url => { :controller => 'admin/statistics' },
      :i18n => true,
      :html => { :class => 'right' }
    }
  ]

  AdminSubMenu = [
    { :title => 'administration',
      :i18n => true,
      :url => [
        { :controller => 'admin/admins' },
        { :controller => 'admin/roles' },
        { :controller => 'admin/rights' }
      ],
      :html => { :class => 'left first'}
    },
    { :title => 'preferences',
      :i18n => true,
      :url => { :controller => 'admin/preferences'},
      :html => { :class => 'left' }
    },
    { :title => 'library',
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
    { :title => 'your_account',
      :i18n => true,
      :url => { :controller => 'admin/account' },
      :html => { :class => 'left' }
    },
    { :title => 'logout',
      :i18n => true,
      :url => { :controller => 'admin/logout' },
      :html => { :class => 'right' }
    },
    { :title => 'support',
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
