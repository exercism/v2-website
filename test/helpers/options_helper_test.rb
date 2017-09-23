require "test_helper"

class OptionsHelperTest < ActiveSupport::TestCase
  test "formats options for select" do
    options = [
      {
        text: "Hello",
        value: 1
      },
      {
        text: "World",
        value: 2
      }
    ]

    expected = { "Hello" => 1, "World" => 2 }

    assert_equal expected, OptionsHelper.format_options(options)
  end

  test "serializes a collection as options" do
    Person = Struct.new(:id, :name)
    user = Person.new(1, "User")
    mentor = Person.new(2, "Mentor")
    expected = [
      { text: "User", value: 1 },
      { text: "Mentor", value: 2 }
    ]

    assert_equal expected, OptionsHelper.as_options([user, mentor], :name, :id)
  end
end
