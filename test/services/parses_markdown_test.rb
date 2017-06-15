require 'test_helper'

class ParsesMarkdownTest < ActiveSupport::TestCase
    test "converts markdown to html" do
    expected = <<-HTML
<h1 id="ohai">OHAI</h1>

<p>Watch this:</p>

<pre><code>$ go home
</code></pre>
    HTML

    actual = ParsesMarkdown.parse <<-MD
# OHAI

Watch this:

```
$ go home
```
MD
    assert_equal expected.chomp, actual.chomp
  end
end
