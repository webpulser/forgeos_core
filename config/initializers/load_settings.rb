if ActiveRecord::Base.connection.tables.include?(Setting.table_name) and settings = Setting.current
  Time.zone = settings.time_zone
  I18n.default_locale = settings.lang.to_sym
  ActionMailer::Base.delivery_method = settings.mailer ? settings.mailer.delivery_method : :test
  ActionMailer::Base.smtp_settings = settings.smtp_settings.marshal_dump if settings.smtp_settings
  ActionMailer::Base.sendmail_settings = settings.sendmail_settings.marshal_dump if settings.sendmail_settings
end