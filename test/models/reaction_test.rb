require 'test_helper'

class ReactionTest < ActiveSupport::TestCase
  test "emotions are correct" do
    create :reaction, emotion: 'love'
    create :reaction, emotion: 'like'
    create :reaction, emotion: 'genius'

    assert_raises ArgumentError do
      create :reaction, emotion: 'urgh'
    end
  end
end
