require 'test_helper'

class FileHelperTest < ActionView::TestCase
  test "syntax highlighting for known filetype" do
    track = create :track, slug: "ruby"
    expected = "language-ruby"
    got = syntax_highlighter_for_filename("filename.rb", track)
    assert_equal expected, got
  end

  test "syntax highlighting for filename with multiple periods" do
    track = create :track, slug: "ruby"
    expected = "language-ruby"
    got = syntax_highlighter_for_filename("file.name.rb", track)
    assert_equal expected, got
  end

  test "syntax highlighting for off-track filetype" do
    track = create :track, slug: "ruby"
    expected = "language-python"
    got = syntax_highlighter_for_filename("filename.py", track)
    assert_equal expected, got
  end

  test "syntax highlighting for unknown filetype" do
    track = create :track, slug: "ruby"
    expected = "language-"
    got = syntax_highlighter_for_filename("filename.zqx", track)
    assert_equal expected, got
  end

  test "syntax highlighting for extensionless filename" do
    track = create :track, slug: "ruby"
    expected = "language-ruby"
    got = syntax_highlighter_for_filename("filename", track)
    assert_equal expected, got
  end

  test "syntax highlighting for filename with only extension" do
    track = create :track, slug: "ruby"
    expected = "language-ruby"
    got = syntax_highlighter_for_filename(".rb", track)
    assert_equal expected, got
  end

  test "syntax highlighting for off-track filename with only extension" do
    track = create :track, slug: "python"
    expected = "language-ruby"
    got = syntax_highlighter_for_filename(".rb", track)
    assert_equal expected, got
  end

  test "syntax highlighting for extensionless dotfile" do
    track = create :track, slug: "ruby"
    expected = "language-"
    got = syntax_highlighter_for_filename(".dotfile", track)
    assert_equal expected, got
  end

end
