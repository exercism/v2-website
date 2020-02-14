require "test_helper"

class Git::TestsInfoTest < ActiveSupport::TestCase
  test "reorders tests based on order in info" do
    tests = [
      stub(test: "OneWordWithTwoVowels"),
      stub(test: "OneWordWithOneVowel")
    ]
    test_info = Git::TestsInfo.new([
      { "test": "OneWordWithOneVowel", cmd: "Vowels('a')" },
      { "test": "OneWordWithTwoVowels", cmd: "Vowels('ae')" }
    ])

    assert_equal(
      ["OneWordWithOneVowel", "OneWordWithTwoVowels"],
      test_info.reorder(tests).map(&:test)
    )
  end

  test "removes tests without a command when reordering" do
    tests = [
      stub(test: "OneWordWithTwoVowels"),
      stub(test: "OneWordWithOneVowel")
    ]
    test_info = Git::TestsInfo.new([
      { "test": "OneWordWithOneVowel", cmd: "Vowels('a')" },
      { "test": "OneWordWithTwoVowels" }
    ])

    assert_equal(
      ["OneWordWithOneVowel"],
      test_info.reorder(tests).map(&:test)
    )
  end
end
