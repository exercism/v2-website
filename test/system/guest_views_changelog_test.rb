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

    visit changelog_path

    assert_text "New exercise"
    assert_text "Introducing 'Hello, world!'"
    assert_text "Created by author1"
    assert_link "View", href: "https://exercism.io/new-exercise"
    assert_selector "img[src='https://exercism.io/image.jpg']"
  end
end
