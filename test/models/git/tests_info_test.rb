require "test_helper"

class Git::TestsInfoTest < ActiveSupport::TestCase
  test "reorders tests based on order in info" do
    tests = [
      stub(name: "OneWordWithTwoVowels"),
      stub(name: "OneWordWithOneVowel")
    ]
    test_info = Git::TestsInfo.new([
      { "name": "OneWordWithOneVowel", cmd: "Vowels('a')" },
      { "name": "OneWordWithTwoVowels", cmd: "Vowels('ae')" }
    ])

    assert_equal(
      ["OneWordWithOneVowel", "OneWordWithTwoVowels"],
      test_info.reorder(tests).map(&:name)
    )
  end

  test "removes tests without a command when reordering" do
    tests = [
      stub(name: "OneWordWithTwoVowels"),
      stub(name: "OneWordWithOneVowel")
    ]
    test_info = Git::TestsInfo.new([
      { "name": "OneWordWithOneVowel", cmd: "Vowels('a')" },
      { "name": "OneWordWithTwoVowels" }
    ])

    assert_equal(
      ["OneWordWithOneVowel"],
      test_info.reorder(tests).map(&:name)
    )
  end
end
