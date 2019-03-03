require "test_helper"

class TimeAgoInWordsHelperTest < ActionView::TestCase
  test "time_ago_in_words calculates time in days, not months" do
    assert_equal "33 days", time_ago_in_words(Time.now - 33.days)
  end

  test "time_ago_in_words calculates time in days" do
    assert_equal "2 days", time_ago_in_words(Time.now - 2.days)
  end

  test "time_ago_in_words calculates time less than one day in hours or minutes" do
    assert_equal "about 2 hours", time_ago_in_words(Time.now - 2.hours)
  end

  test "time_ago_in_words correctly calculates one day plus one second" do
    assert_equal "1 day", time_ago_in_words(Time.now - (SECONDS_PER_DAY + 1))
  end

  test "time_ago_in_words correctly calculates one day minus one second" do
    assert_equal "1 day", time_ago_in_words(Time.now - (SECONDS_PER_DAY - 1))
  end

  test "time_ago_in_words correctly calculates one day minus one minute" do
    assert_equal "about 24 hours", time_ago_in_words(Time.now - (SECONDS_PER_DAY - 60))
  end

  test "time_ago_in_words calculates time in years, not days" do
    assert_equal "about 1 year", time_ago_in_words(Time.now - 366.days)
  end
end
