require 'test_helper'

module Forgeos
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
      assert_equal("Grant Gary", forgeos_people(:active).fullname)
    end

    test "a name of a person is the composition of his firstname then his lastname" do
      assert_equal("Gary Grant", forgeos_people(:active).name)
    end

    test "could activate a person" do
      assert !forgeos_people(:disabled).active?
      forgeos_people(:disabled).activate
      assert forgeos_people(:disabled).active?
    end

    test "could disactivate a person" do
      assert forgeos_people(:active).active?
      forgeos_people(:active).disactivate
      assert !forgeos_people(:active).active?
    end

    test "should generate a password" do
      assert !Person.generate_password(8).blank?
    end
  end

end
