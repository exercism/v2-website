require "test_helper"

class Git::TestsInfoTest < ActiveSupport::TestCase
  test "reorders tests based on order in info" do
    tests = [
      stub(name: "OneWordWithTwoVowels"),
      stub(name: "OneWordWithOneVowel")
    ]
    test_info = Git::TestsInfo.new([
      { "name": "OneWordWithOneVowel" },
      { "name": "OneWordWithTwoVowels" }
    ])

    assert_equal(
      ["OneWordWithOneVowel", "OneWordWithTwoVowels"],
      test_info.reorder(tests).map(&:name)
    )
  end
end
