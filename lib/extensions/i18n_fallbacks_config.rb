require 'i18n/backend/fallbacks'

(I18n.available_locales - [I18n.default_locale]).each do |locale|
  I18n.fallbacks.map(I18n.default_locale => locale)
  I18n.fallbacks[locale]
end

I18n.fallbacks[I18n.default_locale]
