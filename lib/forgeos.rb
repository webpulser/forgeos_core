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

  AdminMenu = []
  AdminSubMenu = []
end
