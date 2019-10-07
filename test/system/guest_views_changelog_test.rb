require "application_system_test_case"

class GuestViewsChangelogTest < ApplicationSystemTestCase
  test "guest views changelog" do
    author = create(:user, handle: "author1")
    track = create(:track, bordered_green_icon_url: "https://exercism.io/image.jpg")
    entry = create(:changelog_entry,
                   title: "New exercise",
                   details_html: "<p>Introducing 'Hello, world!'</p>",
                   referenceable: track,
                   created_by: author,
                   info_url: "https://exercism.io/new-exercise",
                   published_at: Time.utc(2016, 12, 25))

    travel_to(Time.utc(2016, 12, 26)) do
      visit changelog_entries_path
    end

    assert_text "New exercise"
    assert_text "Introducing 'Hello, world!'"
    assert_text "Created by author1"
    assert_text "Published 1 day ago"
    assert_link "View", href: "https://exercism.io/new-exercise"
    assert_selector "img[src='https://exercism.io/image.jpg']"
  end

  test "guest views paginated changelog" do
    create(:changelog_entry,
           title: "New track",
           published_at: Time.utc(2016, 12, 25, 23, 30, 0))
    create(:changelog_entry,
           title: "New exercise",
           published_at: Time.utc(2016, 12, 25, 23, 59, 59))

    visit changelog_entries_path(per_page: 1, page: 1)

    assert_text "New exercise"
    refute_text "New track"
  end

  test "guest views changelog entry" do
    author = create(:user, handle: "author1")
    track = create(:track, bordered_green_icon_url: "https://exercism.io/image.jpg")
    entry = create(:changelog_entry,
                   title: "New exercise",
                   details_html: "<p>Introducing 'Hello, world!'</p>",
                   referenceable: track,
                   created_by: author,
                   info_url: "https://exercism.io/new-exercise",
                   published_at: Time.utc(2016, 12, 25))

    visit changelog_entry_path(entry.url_slug)

    assert_text "New exercise"
    assert_text "Introducing 'Hello, world!'"
    assert_text "Created by author1"
    assert_link "View", href: "https://exercism.io/new-exercise"
    assert_selector "img[src='https://exercism.io/image.jpg']"
  end
end
