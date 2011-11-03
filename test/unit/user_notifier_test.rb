require 'test_helper'

class UserNotifierTest < ActionMailer::TestCase
  test "should send new password" do
    mail = UserNotifier.reset_password(people(:user), 'new_password')
    assert_equal ['john.doe@forgeos.com'], mail.to
    assert_match /new_password/, mail.body
  end

  test "should send import finished" do
    mail = UserNotifier.import_finished('test@test.org', {:total => 100})
    assert_equal ['test@test.org'], mail.to
    assert_match /100/, mail.body
  end
end
