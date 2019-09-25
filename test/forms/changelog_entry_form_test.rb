require "test_helper"

class ChangelogEntryFormTest < ActiveSupport::TestCase
  test "raises error when attempting to save a changelog entry with an unauthorized user" do
    unauthorized_user = create(:user, may_edit_changelog: false)
    form = ChangelogEntryForm.new(title: "Title", created_by: unauthorized_user)

    assert_raises ChangelogEntryForm::UnauthorizedUserError do
      form.save
    end
  end

  test "validates presence of title" do
    user = create(:user)
    form = ChangelogEntryForm.new(title: nil, created_by: user)

    refute form.valid?

    form = ChangelogEntryForm.new(title: "Title", created_by: user)

    assert form.valid?
  end

  test "validates presence of created_by" do
    form = ChangelogEntryForm.new(title: "Title", created_by: nil)

    refute form.valid?

    user = create(:user)
    form = ChangelogEntryForm.new(title: "Title", created_by: user)

    assert form.valid?
  end

  test ".from_entry copies data from entry" do
    track = create(:track)
    entry = create(:changelog_entry,
                   title: "New Exercise",
                   details_markdown: "# We've added a new exercise!",
                   referenceable: track,
                   info_url: "https://github.com/exercism")

    form = ChangelogEntryForm.from_entry(entry)

    assert_equal entry.id, form.id
    assert_equal "New Exercise", form.title
    assert_equal "# We've added a new exercise!", form.details_markdown
    assert_equal "https://github.com/exercism", form.info_url
    assert_equal track.to_global_id, form.referenceable_gid
  end

  test ".from_entry sets referenceable_gid to nil if it does not exist" do
    entry = create(:changelog_entry, referenceable: nil)

    form = ChangelogEntryForm.from_entry(entry)

    assert_nil form.referenceable_gid
  end
end
