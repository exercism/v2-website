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
    form = ChangelogEntryForm.new(title: nil)

    refute form.valid?

    form = ChangelogEntryForm.new(title: "Title")

    assert form.valid?
  end
end
