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
