require 'test_helper'

class ParseMarkdownTest < ActiveSupport::TestCase
    test "converts markdown to html" do
    expected = %q{<h1>OHAI</h1>
<p>So I was split between two ways of doing this.</p>
<ol>
<li>Either method pairs with adjectives (which I did),</li>
<li>Some sort of data structure (e.g. a hash might look like)</li>
</ol>
<p><a href="http://example.com" target="_blank">Some link</a></p>
<p>Watch this:</p>
<pre><code class="language-plain">$ go home
</code></pre>}

    actual = ParseMarkdown.(%q{
# OHAI

So I was split between two ways of doing this.

1. Either method pairs with adjectives (which I did),
2. Some sort of data structure (e.g. a hash might look like)

[Some link](http://example.com)

Watch this:

```
$ go home
```
})
    assert_equal expected.chomp, actual.chomp
  end

  test "doesn't blow up with nil" do
    assert_equal "", ParseMarkdown.(nil)
  end

  test "parses tables" do
    table = <<~TABLE
      1   | 2
      --- | ---
      3   | 4
    TABLE


    expected = <<~HTML
      <table>
      <thead>
      <tr>
      <th>1</th>
      <th>2</th>
      </tr>
      </thead>
      <tbody>
      <tr>
      <td>3</td>
      <td>4</td>
      </tr>
      </tbody>
      </table>
    HTML
    assert_equal expected, ParseMarkdown.(table)
  end
end
