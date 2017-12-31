require_relative '../test_helper'

class CreatesTrackTest < ActiveSupport::TestCase
  test "creates active and inactive tracks" do
    track_a, track_b = nil

    Exercism.stub_const(:PrismLanguages, %w(a b)) do
      track_a = CreatesTrack.create!("A", "a", "http://a.example.com", active: true)
      track_b = CreatesTrack.create!("B", "b", "http://b.example.com", active: false)
    end

    assert_predicate track_a, :active?
    refute_predicate track_b, :active?
  end
end
