require 'test_helper'

module Forgeos
  class SettingTest < ActiveSupport::TestCase
    test "current should be the first" do
      assert_equal Setting.first, Setting.current
    end

    test "should give smtp_settings" do
      setting = Setting.new
      assert_equal({}, setting.smtp_settings)
    end

    test "should give smtp_settings with enable_starttls_auto as boolean" do
      setting = Setting.new(:smtp_settings => { :enable_starttls_auto => '1'})
      assert_equal({:enable_starttls_auto => true}, setting.smtp_settings)
    end

    test "should write smtp_settings" do
      setting = Setting.new
      setting.smtp_settings = { :toto => 1}
      assert_equal({ :toto => 1 }, setting.smtp_settings)
    end

    test "should persist smtp_settings" do
      new_params = { :toto => 1 }
      setting = Setting.new(:name => 'test')
      setting.smtp_settings = new_params
      setting.save
      assert setting.valid?, 'setting is invalid and should not be'
      assert_equal(new_params, setting.smtp_settings)
      assert_equal(new_params, setting.reload.smtp_settings)
    end

    test "should remove authentication and user_name and password from smtp_settings if authentication is none" do
      setting = Setting.new
      setting.smtp_settings = {
        :authentication => 'none',
        :user_name => 'test',
        :password => 'test',
        :toto => 1
      }
      assert_equal({ :toto => 1 }, setting.smtp_settings)
    end


    test "should write mailer" do
      setting = Setting.new
      setting.mailer = { :toto => 1}
      assert_equal({ :toto => 1 }, setting.mailer)
    end

    test "should persist mailer" do
      setting = Setting.new(:name => 'test')
      setting.mailer = { :toto => 1}
      setting.save
      assert_equal({ :toto => 1 }, Setting.last.mailer)
    end

    test "should write sendmail_settings" do
      setting = Setting.new
      setting.sendmail_settings = { :toto => 1}
      assert_equal({ :toto => 1 }, setting.sendmail_settings)
    end

    test "should persist sendmail_settings" do
      setting = Setting.new(:name => 'test')
      setting.sendmail_settings = { :toto => 1}
      setting.save
      assert_equal({ :toto => 1 }, Setting.last.sendmail_settings)
    end
  end
end
