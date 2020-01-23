require 'test_helper'

class TerminalOutputTest < ActiveSupport::TestCase
  test "to_html parses normal text" do
    assert_equal "ran@xub", TerminalOutput.new("ran@xub").to_html
  end

<<<<<<< Updated upstream
=======
  test "to_html parses ansi" do
    assert_equal "<span style='color:#A00;'>Hello</span><span style='color:#00A;'>World</span>", TerminalOutput.new("\e[31mHello\e[0m\e[34mWorld\e[0").to_html
  end

>>>>>>> Stashed changes
  test "to_html copes with nil" do
    assert_nil TerminalOutput.new(nil).to_html
  end
end


