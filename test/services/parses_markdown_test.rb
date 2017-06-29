require 'test_helper'

class ParsesMarkdownTest < ActiveSupport::TestCase
    test "converts markdown to html" do
    expected = <<-HTML
<h1>OHAI</h1>

<p>So I was split between two ways of doing this.<br>
1) Either method pairs with adjectives (which I did),<br>
2) Some sort of data structure (e.g. a hash might look like)</p>

<p>Watch this:</p>
<pre><code class="language-ruby">$ go home
</code></pre>
    HTML

    actual = ParsesMarkdown.parse <<-MD
# OHAI

So I was split between two ways of doing this.
1) Either method pairs with adjectives (which I did),
2) Some sort of data structure (e.g. a hash might look like)

Watch this:

```
$ go home
```
MD
    assert_equal expected.chomp, actual.chomp
  end
end
