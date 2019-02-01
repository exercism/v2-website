require 'test_helper'

class ProfilePresenterTest < ActiveSupport::TestCase
  test "filters solutions correctly" do
    user = create :user
    profile = create :profile, user: user
    ruby = create :track, title: "Ruby"
    python = create :track, title: "Python"
    java = create :track, title: "Java"

    profile_ruby_solution = create :solution, user: user, published_at: DateTime.now, show_on_profile: true, exercise: create(:exercise, track: ruby)
    profile_python_solution = create :solution, user: user, published_at: DateTime.now, show_on_profile: true, exercise: create(:exercise, track: python)

    published_solution = create :solution, user: user, published_at: DateTime.now, show_on_profile: false, exercise: create(:exercise, track: java)
    other_solution = create :solution
    other_persons_profile_solution = create :solution, published_at: DateTime.now, show_on_profile: true

    assert_equal [profile_ruby_solution, profile_python_solution].sort, ProfilePresenter.new(user).solutions.sort
    assert_equal [profile_python_solution], ProfilePresenter.new(user, track_id: python.id).solutions

    expected = [["Any", 0], [ruby.title, ruby.id], [python.title, python.id]]
    assert_equal expected, ProfilePresenter.new(user, track_id: python.id).tracks_for_select
  end
end

