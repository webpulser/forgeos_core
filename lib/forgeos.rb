module Forgeos
  class Statistics
    def self.total_of_visitors(date = nil)
      return 0
    end
  end

  # Set administration's menu
  AdminMenu = [
    { :title => 'dashboard',
      :url => { :controller => 'admin/dashboard' },
      :i18n => true,
      :html => { :class => 'left'}
    },
    { :title => 'site_builder',
      :url => { :controller => 'admin/product_types'},
      :i18n => true,
      :html => { :class => 'right' } },
    { :title => 'statistics',
      :url => { :controller => 'admin/statistics' },
      :i18n => true,
      :html => { :class => 'right' } },
    { :title => 'marketing', 
      :i18n => true,
      :url => { :controller => 'admin/special_offers', :action => 'new'},
      :html => { :class => 'right' } }
  ]

  AdminSubMenu = [
    { :title => 'administration',
      :i18n => true,
      :url => { :controller => 'admin/admins' },
      :html => { :class => 'left first'}
    },
    { :title => 'preferences',
      :i18n => true,
      :url => { :controller => 'admin/preferences'},
      :html => { :class => 'left' }
    },
    { :title => 'library',
      :i18n => true,
      :url => { :controller => 'admin/library' },
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
      :html => { :class => 'right' }
    },
    { :title => 'see_site',
      :i18n => true,
      :url => :root,
      :html => { :class => 'right first' }
    }
  ]
  
  # Set site's menu
  Menu = []
  # Set attachable media types
  AttachableTypes = []


  def self.url_generator(phrase = '')
    url = phrase.dup
    { %w(á à â ä ã Ã Ä Â À) => 'a',
      %w(é è ê ë Ë É È Ê €) => 'e',
      %w(í ì î ï I Î Ì) => 'i',
      %w(ó ò ô ö õ Õ Ö Ô Ò) => 'o',
      %w(œ) => 'oe',
      %w(ß) => 'ss',
      %w(ú ù û ü U Û Ù) => 'u',
      %w(\/ \| \\ \\& = # ' ") => '',
      %w(\s+) => '_'
    }.each do |ac,rep|
      url.gsub!(Regexp.new(ac.join('|')), rep)
    end

    url.underscore.gsub(/(^_+|_+$)/,'')
  end
end
