class UserNotifier < ActionMailer::Base
  def reset_password(user, password)
    @user = user
    @password = password
    mail(
      :from => 'contact@forgeos.com',
      :to => "#{user.firstname} #{user.lastname} <#{user.email}>",
      :subject => I18n.t('admin.reset_password_mail')
    )
  end

  def import_finished(email, results)
    @results = results
    mail(
      :from => 'contact@forgeos.com',
      :to => email,
      :subject => I18n.t('admin.import.finished')
    )
  end
end
