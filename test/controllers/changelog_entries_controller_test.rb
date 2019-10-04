require 'test_helper'

class ChangelogEntriesControllerTest < ActionDispatch::IntegrationTest
  test "#show raises an error when viewing an unpublished entry" do
    entry = create(:changelog_entry, published_at: nil)

    assert_raises ActiveRecord::RecordNotFound do
      get changelog_entry_path(entry)
    end
  end
end
