require 'test_helper'

module Forgeos
  class RuleTest < ActiveSupport::TestCase
    test "should toggle activate" do
      rule = Rule.new

      assert_equal true, rule.active?
      rule.activate
      assert_equal false, rule.active?
      rule.activate
      assert_equal true, rule.active?
    end

    test "should toggle activate with children" do
      rule = Rule.new
      child_rule = Rule.new
      rule.children << child_rule

      assert_equal true, child_rule.active?
      rule.activate
      assert_equal false, child_rule.active?
      rule.activate
      assert_equal true, child_rule.active?
    end

    test "should delegate name to his parent" do
      rule = Rule.create(:name => 'toto')
      child_rule = Rule.create(:parent => rule)

      assert_equal rule, child_rule.parent
      assert_equal 'toto', child_rule.name
      child_rule.name = 'tata'
      assert_equal 'tata', child_rule.name
    end

    test "should delegate description to his parent" do
      rule = Rule.create(:description => 'toto')
      child_rule = Rule.create(:parent => rule)

      assert_equal 'toto', child_rule.description
      child_rule.description = 'tata'
      assert_equal 'tata', child_rule.description
    end

  end
end
