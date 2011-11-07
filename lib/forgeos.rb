# coding: utf-8
# encoding: utf-8
module Forgeos
  autoload :Statistics, 'forgeos/statistics'
  autoload :Urlified, 'forgeos/urlified'

  def self.url_generator(phrase = '', sep = '-')
    phrase.dup.parameterize(sep)
  end

  AdminMenu = []
  AdminSubMenu = []
end
