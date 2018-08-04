require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "url_with_protocol adds https to the url" do
    assert_equal "https://linkedin.com/in/alice",
                 url_with_protocol("linkedin.com/in/alice")
  end

  test "url_with_protocol returns http url with https" do
    assert_equal "https://linkedin.com/in/alice",
                 url_with_protocol("http://linkedin.com/in/alice")
  end

  test "url_with_protocol returns https url without change" do
    assert_equal "https://linkedin.com/in/alice",
                 url_with_protocol("https://linkedin.com/in/alice")
  end
end
