ruby = Track.create!(title: "Ruby", slug: "seed_ruby")
python = Track.create!(title: "Python", slug: "seed_python")

slug = Exercise.create!(track: ruby, title: "Slug", slug: "slug", uuid: SecureRandom.uuid, core: true, position: 1)
bob = Exercise.create!(track: ruby, title: "Bob", slug: "bob", uuid: SecureRandom.uuid, core: true, position: 2)
fish = Exercise.create!(track: ruby, title: "Fish", slug: "fish", uuid: SecureRandom.uuid, core: true, position: 3)
Exercise.create!(track: ruby, title: "Snail", slug: "snail", uuid: SecureRandom.uuid, core: true, position: 4)
Exercise.create!(track: ruby, title: "Desk", slug: "desk", uuid: SecureRandom.uuid, core: true, position: 6)
Exercise.create!(track: ruby, title: "Coffee", slug: "coffee", uuid: SecureRandom.uuid, core: true, position: 5)

cat = Exercise.create!(track: ruby, title: "Cat", slug: "cat", uuid: SecureRandom.uuid, core: false, unlocked_by: bob)
mouse = Exercise.create!(track: ruby, title: "Mouse", slug: "mouse", uuid: SecureRandom.uuid, core: false, unlocked_by: fish)
Exercise.create!(track: ruby, title: "Cover", slug: "cover", uuid: SecureRandom.uuid, core: false, active: false)
Exercise.create!(track: ruby, title: "Laptop", slug: "laptop", uuid: SecureRandom.uuid, core: false)
Exercise.create!(track: ruby, title: "Bag", slug: "bag", uuid: SecureRandom.uuid, core: false, unlocked_by: slug)

topic_strings = Topic.create(slug: "strings")
slug.topics << topic_strings
cat.topics << topic_strings
mouse.topics << topic_strings

ihid = User.create!(name: "Jeremy Walker", email: "jeremy@thalamus.ai", password: 'password', admin: true)
kytrinyx = User.create!(name: "Kytrinyx", email: "kytrinyx@thalamus.ai", password: 'password', admin: true)

ihid_ruby = UserTrack.create!(user: ihid, track: ruby)
ihid_slug = Solution.create!(user: ihid, exercise: slug, approved_by: kytrinyx, git_slug: 'foobar', git_sha: 'foobar', completed_at: DateTime.now, published_at: DateTime.now)
ihid_slug_iteration_1 = Iteration.create!(solution: ihid_slug, code: "CODE")
ihid_slug_reaction = Reaction.create(user: kytrinyx, solution: ihid_slug, emotion: :wowed, comment: "This is sick")

ihid_bob = Solution.create!(user: ihid, exercise: bob, approved_by: kytrinyx, git_slug: 'foobar', git_sha: 'foobar')
ihid_bob_iteration_1 = Iteration.create!(solution: ihid_bob, code: %q{
class Bob
  RESPONSES = {
    silent:   'Fine. Be that way.',
    asking:   'Sure.',
    shouting: 'Woah, chill out!',
    default:  'Whatever.'
  }

  def hey(text)
    tone = ToneDeterminer.determine_tone(text)
    RESPONSES[tone]
  end
end

class ToneDeterminer
  class << self
    def determine_tone(text)
      new(text).tone
    end
  end

  ADJECTIVES = %w{silent shouting asking}
  attr_reader :text

  def initialize(text)
    @text = text
  end

  def tone
    ADJECTIVES.each do |adjective|
      return adjective.to_sym if send("#{adjective}?")
    end
    :default
  end

  private
    def silent?
      text.to_s.empty?
    end

    def asking?
      text.end_with?("?")
    end

    def shouting?
      text.upcase == text
    end
end
%}.strip)

iteration1_discussion1 = ihid_bob_iteration_1.discussion_posts.create!(user: kytrinyx, content: "not-blank", html: %q{<p>I really like the adjectives, and the predicate methods that they're used for. I like how the responder allows you to save the text as an instance variable without running into thread-safety issues.</p><p>I feel like the meta-programming is making it hard to see which responses go with which tones, even though you've named the methods in a very expressive way.</p>})

iteration1_discussion2_content = %q{
Great feedback. Thank you.

So I was split between two ways of doing this.
1) Either method pairs with adjectives (which I did),
2) Some sort of data structure (e.g. a hash might look like)

```
{
->{text.to_s.empty?} => 'Fine. Be that way.',
->{text.upcase == text} => "Woah, chill out!",
->{text.end_with?("?")} => "Sure."
}
```

The main reason for the structure would be to link the response to the tone more clearly, which I entirely agree is unclear with the first option. However, I think the hash is just too ugly, and it seemed to be getting overkill to make a whole new structure, or a multi-dimensional array. I also don't think this idea scales for more complex methods.

A better option might be to have the "respond_to_silent" method, do a check and respond, then return true/false. This would link them better. However, I like the ability have separation between what counts as shouting, and how to respond, for single responsibility of methods.

Splitting the pairs into classes would work well (Shout/Silent/Asking classes with a checker/responder). Feels again a little overkill though.

Very happy to hear any suggestions :)
}
iteration1_discussion2 = ihid_bob_iteration_1.discussion_posts.create!(user: ihid, content: iteration1_discussion2_content, html: ParsesMarkdown.parse(iteration1_discussion2_content))

TrackMentorship.create(user: ihid, track: python)
user1 = User.create!(name: "User 1", email: "#{SecureRandom.uuid}@example.com", password: 'password')
user2 = User.create!(name: "User 2", email: "#{SecureRandom.uuid}@example.com", password: 'password')
user3 = User.create!(name: "User 3", email: "#{SecureRandom.uuid}@example.com", password: 'password')
user4 = User.create!(name: "User 4", email: "#{SecureRandom.uuid}@example.com", password: 'password')

python_hello_world = Exercise.create!(track: python, title: "Hello World", slug: "hello-world", uuid: SecureRandom.uuid, core: true, position: 2)

user1_hello_world = Solution.create!(user: user1, exercise: python_hello_world, git_slug: 'foobar', git_sha: 'foobar')
user1_hello_world_iteration_1 = Iteration.create!(solution: user1_hello_world, code: "foo")
user1_hello_world_iteration_2 = Iteration.create!(solution: user1_hello_world, code: "bar")
SolutionMentorship.create(user: ihid, solution: user1_hello_world, requires_action: true)

user2_hello_world = Solution.create!(user: user2, exercise: python_hello_world, git_slug: 'foobar', git_sha: 'foobar')
user2_hello_world_iteration_1 = Iteration.create!(solution: user2_hello_world, code: "foo")
SolutionMentorship.create(user: ihid, solution: user2_hello_world)

user3_hello_world = Solution.create!(user: user3, exercise: python_hello_world, git_slug: 'foobar', git_sha: 'foobar')
user3_hello_world_iteration_1 = Iteration.create!(solution: user3_hello_world, code: "foo")

# Seed tracks
CreatesTrack.create_all!
