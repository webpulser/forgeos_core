if ActiveRecord::Base.connection.tables.include?(Setting.table_name) && settings = Setting.first
  zone_default = Time.__send__(:get_zone, settings.time_zone)
  Time.zone_default = zone_default
  I18n.default_locale = settings.lang.to_sym
  ActionMailer::Base.delivery_method = settings.mailer ? settings.mailer.delivery_method : :smtp
  ActionMailer::Base.smtp_settings = settings.smtp_settings.marshal_dump if settings.smtp_settings
  ActionMailer::Base.sendmail_settings = settings.sendmail_settings.marshal_dump if settings.sendmail_settings
end
