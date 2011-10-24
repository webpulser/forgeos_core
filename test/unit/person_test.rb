require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  test "couldn't create a person with malformed email" do
    person = Person.new(
      :firstname => 'toto',
      :lastname => 'toto',
      :email => 'toto',
      :password => 'toto',
      :password_confirmation => 'toto'
    )
    assert(!person.valid?)
  end

  test "could create a person" do
    person = Person.new(
      :firstname => 'toto',
      :lastname => 'toto',
      :email => 'toto@test.org',
      :password => 'toto',
      :password_confirmation => 'toto'
    )
    assert person.valid?
  end

  test "verify the password confirmation of a person" do
    person = Person.new(
      :firstname => 'toto',
      :lastname => 'toto',
      :email => 'toto@test.org',
      :password => 'toto',
      :password_confirmation => 'titi'
    )
    assert(!person.valid?)
  end

  test "could disable presence of firstname" do
    Person.class_eval do
      def skip_presence_of_firstname?
        true
      end
    end
    person = Person.new(
      :lastname => 'toto',
      :email => 'toto@test.org',
      :password => 'toto',
      :password_confirmation => 'toto'
    )
    assert person.valid?

  end

  test "could disable presence of lastname" do
    Person.class_eval do
      def skip_presence_of_lastname?
        true
      end
    end
    person = Person.new(
      :firstname => 'toto',
      :email => 'toto@test.org',
      :password => 'toto',
      :password_confirmation => 'toto'
    )
    assert person.valid?
  end

  test "could disable uniqueness of email" do
    Person.class_eval do
      def skip_uniqueness_of_email?
        true
      end
    end
    person = Person.new(
      :firstname => 'Jimi',
      :lastname => 'Hendrix',
      :email => 'jimi.hendrix@forgeos.com',
      :password => 'toto',
      :password_confirmation => 'toto'
    )
    assert person.valid?
  end

  test "a fullname of a person is the composition of his lastname then his firstname" do
    assert_equal("Grant Gary", people(:active).fullname)
  end

  test "a name of a person is the composition of his firstname then his lastname" do
    assert_equal("Gary Grant", people(:active).name)
  end

  test "could activate a person" do
    assert !people(:disabled).active?
    people(:disabled).activate
    assert people(:disabled).active?
  end

  test "could disactivate a person" do
    assert people(:active).active?
    people(:active).disactivate
    assert !people(:active).active?
  end
end
