module Forgeos
  # Set administration's menu
  AdminMenu = [
    { :title => 'dashboard',
      :url => { :controller => 'admin/dashboard' }, :i18n => true,
      :html => { :class => 'left'}
    },
    { :title => 'statistics',
      :url => { :controller => 'admin/stats' },
      :html => { :class => 'right' } },
    { :title => 'marketing', 
      :url => { :controller => 'admin/marketing' },
      :html => { :class => 'right' } }
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
      %w(\/ \| \\ \\& = #) => '',
      %w(\s+) => '_'
    }.each do |ac,rep|
      url.gsub!(Regexp.new(ac.join('|')), rep)
    end

    url.underscore.gsub(/(^_+|_+$)/,'')
  end
end
