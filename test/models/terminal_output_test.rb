require 'test_helper'

class TerminalOutputTest < ActiveSupport::TestCase
  test "to_html parses normal text" do
    assert_equal "ran@xub", TerminalOutput.new("ran@xub").to_html
  end

  test "to_html copes with nil" do
    assert_nil TerminalOutput.new(nil).to_html
  end
end


