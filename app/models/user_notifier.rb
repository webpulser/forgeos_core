class UserNotifier < ActionMailer::Base
  def reset_password(user, password)
    content_type "text/html; charset=utf-8"

    recipients "#{user.firstname} #{user.lastname} <#{user.email}>"
    from       "contact@forgeos.com"
    subject    "#{I18n.t('admin.reset_password_mail')}"
    body       :user => user, :password => password
  end
end