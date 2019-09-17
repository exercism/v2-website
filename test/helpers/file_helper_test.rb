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
    expected = "language-ruby"
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
    expected = "language-ruby"
    got = syntax_highlighter_for_filename(".dotfile", track)
    assert_equal expected, got
  end

  test "syntax highlighting for ambiguous perl filetype" do
    perl_track = create :track, slug: "perl"
    expected_perl = "language-perl"
    got_perl = syntax_highlighter_for_filename("filename.pl", perl_track)
    assert_equal expected_perl, got_perl
  end

  test "syntax highlighting for ambiguous prolog filetype" do
    prolog_track = create :track, slug: "prolog"
    expected_prolog = "language-prolog"
    got_prolog = syntax_highlighter_for_filename("filename.pl", prolog_track)
    assert_equal expected_prolog, got_prolog
  end

end
