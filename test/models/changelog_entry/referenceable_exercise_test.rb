require "test_helper"

class ChangelogEntry::ReferenceableExerciseTest < ActiveSupport::TestCase
  test "#twitter_account returns track twitter account" do
    track = create(:track, slug: "ruby")
    exercise = create(:exercise, track: track)
    referenceable = ChangelogEntry::ReferenceableExercise.new(exercise)

    assert_equal TwitterAccount.find(:ruby), referenceable.twitter_account
  end
end
