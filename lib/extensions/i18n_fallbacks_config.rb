require 'i18n/backend/fallbacks'

I18n.available_locales.each do |locale|
  I18n.fallbacks.map(I18n.default_locale => locale) unless locale.to_sym == I18n.default_locale.to_sym
  I18n.fallbacks[locale]
end
