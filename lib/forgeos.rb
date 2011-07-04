# coding: utf-8
# encoding: utf-8
module Forgeos
  autoload :Statistics, 'forgeos/statistics'
  autoload :Urlified, 'forgeos/urlified'

  def self.url_generator(phrase = '', sep = '-')
    return '' if phrase.nil?
    url = phrase.dup
    { %w(á à â ä ã Ã Ä Â À) => 'a',
      %w(é è ê ë Ë É È Ê €) => 'e',
      %w(í ì î ï I Î Ì) => 'i',
      %w(ó ò ô ö õ Õ Ö Ô Ò) => 'o',
      %w(ç) => 'c',
      %w(œ) => 'oe',
      %w(ß) => 'ss',
      %w(ú ù û ü U Û Ù) => 'u',
      %w(\/ \| & = # ' " \?) => '',
      %w(\s+ _) => sep
    }.each do |ac,rep|
      url.gsub!(Regexp.new(ac.join('|')), rep)
    end

    url.squeeze(sep).gsub(/(^#{sep}+|#{sep}+$)/,'').downcase
  end

  AdminMenu = [
    { :title => 'back_office.menu.dashboard',
      :url => '/admin/dashboard',
      :i18n => true,
      :html => { :class => 'left first'}
    },
    { :title => 'back_office.menu.users',
      :url => '/admin/users',
      :i18n => true,
      :html => { :class => 'left'}
    },
    { :title => 'back_office.menu.statistics',
      :url => '/admin/statistics',
      :i18n => true,
      :html => { :class => 'right' }
    }
  ]

  AdminSubMenu = [
    { :title => 'back_office.menu.administration',
      :i18n => true,
      :url => [
        '/admin/administrators',
        '/admin/roles',
        '/admin/rights'
      ],
      :html => { :class => 'left first'}
    },
    { :title => 'back_office.menu.settings',
      :i18n => true,
      :url => '/admin/setting',
      :html => { :class => 'left' }
    },
    { :title => 'back_office.menu.library',
      :i18n => true,
      :url => [
        '/admin/library',
        '/admin/images/attachments',
        '/admin/pdf/attachments',
        '/admin/audio/attachments',
        '/admin/video/attachments',
        '/admin/media/attachments',
        '/admin/doc/attachments'
      ],
      :html => { :class => 'left' }
    },
    { :title => 'back_office.menu.accounts',
      :i18n => true,
      :url => '/admin/account',
      :html => { :class => 'left' }
    },
    { :title => 'back_office.menu.logout',
      :i18n => true,
      :url => '/admin/logout',
      :html => { :class => 'right' }
    },
    { :title => 'back_office.menu.support',
      :i18n => true,
      :url => 'http://www.webpulser.com',
      :html => { :class => 'right first' }
    }
  ]
end
