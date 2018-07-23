require 'test_helper'

class ParsesMarkdownTest < ActiveSupport::TestCase
    test "converts markdown to html" do
    expected = <<-HTML
<h1>OHAI</h1>

<p>So I was split between two ways of doing this.</p>

<ol>
<li>Either method pairs with adjectives (which I did),</li>
<li>Some sort of data structure (e.g. a hash might look like)</li>
</ol>

<p><a href="http://example.com" target="_blank">Some link</a></p>

<p>Watch this:</p>
<pre><code class="language-plain">$ go home
</code></pre>
    HTML

    actual = ParsesMarkdown.parse <<-MD
# OHAI

So I was split between two ways of doing this.

1. Either method pairs with adjectives (which I did),
2. Some sort of data structure (e.g. a hash might look like)

[Some link](http://example.com)

Watch this:

```
$ go home
```
MD
    assert_equal expected.chomp, actual.chomp
  end

  test "doesn't blow up with nil" do
    assert_equal "", ParsesMarkdown.parse(nil)
  end
end
