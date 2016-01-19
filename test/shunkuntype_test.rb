require 'test_helper'
require 'test/unit'
#class ShunkuntypeTest < Minitest::Test

module Test::Unit
  # Used to fix a minor minitest/unit incompatibility in flexmock
#  AssertionFailedError = Class.new(StandardError)

  class TestCase

    def self.must(name, &block)
      p name
      test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
      defined = instance_method(test_name) rescue false
      raise "#{test_name} is already defined in #{self}" if defined
      if block_given?
        define_method(test_name, &block)
      else
        define_method(test_name) do
          flunk "No implementation provided for #{name}"
        end
      end
    end

  end
end

class ShunkuntypeTest < Test::Unit::TestCase
  must "it has a version number" do
    refute_nil ::Shunkuntype::VERSION
  end

end
