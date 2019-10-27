require 'test_helper'

class ExerciseFixtureTest < ActiveSupport::TestCase
  test "hash is created" do
    representation = "something goes here. it can be very long"
    fixture = create :exercise_fixture, representation: representation
    hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), "notverysecret", representation)
    assert_equal hash, fixture.representation_hash
  end

  test "lookup" do
    exercise = create :exercise
    representation = "some foobar"

    create :exercise_fixture, exercise: exercise
    create :exercise_fixture, representation: representation

    # Check all things are fulfilled
    assert_nil ExerciseFixture.lookup(exercise.track.slug, exercise.slug, representation)

    # Check the correct one is found
    fixture = create :exercise_fixture, exercise: exercise, representation: representation
    assert_equal fixture, ExerciseFixture.lookup(exercise.track.slug, exercise.slug, representation)
  end
end
