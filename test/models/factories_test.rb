require_relative '../test_helper'

class Factories < ActiveSupport::TestCase
  FactoryGirl.factories.map(&:name).each do |factory|
    test factory.to_s do
      create factory
    end
  end
end
