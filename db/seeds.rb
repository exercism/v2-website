ihid = User.create!(name: "Jeremy Walker", handle: 'iHiD', email: "jeremy@thalamus.ai", password: 'password', admin: true)

=begin
ruby = Track.create!(title: "Ruby", slug: "seed_ruby", repo_url: "http://example.com/ruby.git", introduction: "", about: "", code_sample: "", syntax_highligher_language: )
python = Track.create!(title: "Python", slug: "seed_python", repo_url: "http://example.com/python.git", introduction: "", about: "", code_sample: "")

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

ihid = User.create!(name: "Jeremy Walker", handle: 'iHiD', email: "jeremy@thalamus.ai", password: 'password', admin: true)
kytrinyx = User.create!(name: "Kytrinyx", handle: 'kytrinyx', email: "kytrinyx@thalamus.ai", password: 'password', admin: true)

TrackMentorship.create(user: ihid, track: ruby)
TrackMentorship.create(user: kytrinyx, track: ruby)

UserTrack.create!(user: ihid, track: ruby)
UserTrack.create!(user: ihid, track: python)

ihid_slug = Solution.create!(user: ihid, exercise: slug, approved_by: kytrinyx, git_slug: 'foobar', git_sha: 'foobar', completed_at: DateTime.now, published_at: DateTime.now)
ihid_slug_iteration_1 = Iteration.create!(solution: ihid_slug)
ihid_slug_reaction = Reaction.create(user: kytrinyx, solution: ihid_slug, emotion: :genius, comment: "This is sick")

ihid_bob = Solution.create!(user: ihid, exercise: bob, approved_by: kytrinyx, git_slug: 'foobar', git_sha: 'foobar')
ihid_bob_iteration_1 = Iteration.create!(solution: ihid_bob)
=begin
IterationFile.create(iteration: ihid_bob_iteration_1
, code: %q{
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
user1 = User.create!(name: "User 1", handle: "u1", email: "#{SecureRandom.uuid}@example.com", password: 'password')
user2 = User.create!(name: "User 2", handle: "u2", email: "#{SecureRandom.uuid}@example.com", password: 'password')
user3 = User.create!(name: "User 3", handle: "u3", email: "#{SecureRandom.uuid}@example.com", password: 'password')
user4 = User.create!(name: "User 4", handle: "u4", email: "#{SecureRandom.uuid}@example.com", password: 'password')

python_hello_world = Exercise.create!(track: python, title: "Hello World", slug: "hello-world", uuid: SecureRandom.uuid, core: true, position: 2)

user1_hello_world = Solution.create!(user: user1, exercise: python_hello_world, git_slug: 'foobar', git_sha: 'foobar')
#user1_hello_world_iteration_1 = Iteration.create!(solution: user1_hello_world, code: "foo")
#user1_hello_world_iteration_2 = Iteration.create!(solution: user1_hello_world, code: "bar")
#SolutionMentorship.create(user: ihid, solution: user1_hello_world, requires_action: true)

#user2_hello_world = Solution.create!(user: user2, exercise: python_hello_world, git_slug: 'foobar', git_sha: 'foobar')
#user2_hello_world_iteration_1 = Iteration.create!(solution: user2_hello_world, code: "foo")
#SolutionMentorship.create(user: ihid, solution: user2_hello_world)

#user3_hello_world = Solution.create!(user: user3, exercise: python_hello_world, git_slug: 'foobar', git_sha: 'foobar')
#user3_hello_world_iteration_1 = Iteration.create!(solution: user3_hello_world, code: "foo")

=end

# Seed tracks
Git::SeedsTracks.seed!

Testimonial.create!(
  headline: "Exercism is a great website",
  content: "Exercism is a great website where I was able to have some very interesting challenges.",
  byline: "Bud Chirica, Scotland"
)
#https://avatars3.githubusercontent.com/u/7063792?v=4&s=400

Testimonial.create!(
  headline: "Exercism is a great website",
  content: "What I like about it is that I am able to solve the challenges in a TDD way working in a environment that I am familiar (my own PC not a browser IDE) and the cherry on the top of the cake is that I have access to code reviews.",
  byline: "Bud Chirica, Scotland"
)
#https://avatars3.githubusercontent.com/u/7063792?v=4&s=400

Testimonial.create!(
  headline: "Exercism is a great website",
  content: "The reviews are incredibly helpful because they help me see things that I missed, learn about new ways and sometimes interesting discussions that can add a fun twist to maybe a simple problem.",
  byline: "Bud Chirica, Scotland"
)
#https://avatars3.githubusercontent.com/u/7063792?v=4&s=400

Testimonial.create!(
  track: Track.find_by_slug!('haskell'),
  headline: "To me, the standout track has been the Haskell track.",
  content: "With only a very limited grasp of functional programming, the frequent and insightful comments I received were invaluable in getting to know the language.",
  byline: "Erik Schierboom, Arnhem"
)
# https://avatars0.githubusercontent.com/u/135246?v=4&s=460

Testimonial.create!(
  track: Track.find_by_slug!('csharp'),
  headline: "The c# markdown problem is my favourite",
  content: "The c# markdown problem is my favourite, it is sufficiently complex to be interesting, and is similar to a lot of the code that I see. Writing good quality code from scratch is generally easier than refactoring existing bad quality code to make it good.",
  byline: "Ceddly Burge"
)
# https://avatars3.githubusercontent.com/u/13573831?v=4&s=460

Testimonial.create!(
  track: Track.find_by_slug!('ruby'),
  headline: "I loved the Ruby track ",
  content: "I loved the Ruby track (it is the only one I have finished so far). Solving over 80 different problems seems one of the most exciting ways to learn a language one barely knows. Improving my own solutions for readability and beauty rather than just passing the tests and performance taught me a little about Ruby and programming in general. I also liked comparing my solution to other ones - I could see the problem from other points of view.",
  byline: "Michał, Poland"
)
# https://avatars3.githubusercontent.com/u/24194784?v=4&s=400

Testimonial.create!(
  track: Track.find_by_slug!('mips'),
  headline: "I'm having a ton of fun doing it.",
  content: "I'm a newcomer to exercism.io. I've been working as a systems engineer for about a year and I've been putting off learning assembly properly (I don't have a degree). I've been doing the MIPS track and not only do I feel like I am really increasing my level of insight into the inner workings of the machine, I'm having a ton of fun doing it. Thank you so much to everyone who is putting work into this.",
  byline: "James Lowenthal, NY"
)
#https://avatars1.githubusercontent.com/u/11030923?v=4&s=460

Testimonial.create!(
  track: Track.find_by_slug!('fsharp'),
  headline: "I really like the ability to look at other people's solutions.",
  content: "I'm working through the F# and Python tracks at the moment. Really like the ability to look at other people's solutions. I've had some helpful comments from others too.",
  byline: "Nick Delany, Ireland"
)
#https://avatars2.githubusercontent.com/u/100827?v=4&s=460

Testimonial.create!(
  track: Track.find_by_slug!('python'),
  headline: "I really like the ability to look at other people's solutions.",
  content: "I'm working through the F# and Python tracks at the moment. Really like the ability to look at other people's solutions. I've had some helpful comments from others too.",
  byline: "Nick Delany, Ireland"
)
#https://avatars2.githubusercontent.com/u/100827?v=4&s=460
#
#

Testimonial.create!(
  track: Track.find_by_slug!('javascript'),
  headline: "I learned so much by osmosis just from reading.",
  content: "Exercism has been really wonderful for me. It was the first time that I ever contributed to an open source project (it's a nice feeling knowing that when people use Exercism I may have helped them in some way), how I learned JavaScript, and how I learned about testing and TDD. I learned so much by osmosis just from reading.",
  byline: "Alexis La Porte"
)
#https://avatars0.githubusercontent.com/u/12205520?v=4&s=460


Testimonial.create!(
  headline: "A tremendous learning opportunity to explore the depth of your own knowledge",
  content: "Exercism is fantastic in learning new languages but that is not the extent of it. If you are a \"more experienced\" programmer you may have encountered impostor syndrome: the idea you don't really know what you think you know. Exercism lets you solve problems and put them in the space of open feedback which is a tremendous learning opportunity to explore the depth of your own knowledge. Even if you have been programming in a language for awhile it is worth checking into Exercism to see where you stand with current implementation practices.",
  byline: "Tom Leen, Portland"
)


Testimonial.create!(
  track: Track.find_by_slug!('python'),
  headline: "The track also improved my ability to understand a problem and form questions around it",
  content: "I started with the Python track which helped me to better understand the language's syntax and data structures. The track also improved my ability to understand a problem and form questions around it so that I was able to find or learn what I needed to in order to find a solution.",
  byline: "Rob Phoenix"
)
#https://avatars1.githubusercontent.com/u/9257284?v=4&s=460

Testimonial.create!(
  track: Track.find_by_slug!('clojure'),
  headline: "Self-contained finite problems with which to learn the language",
  content: "I have spent time with the Clojure, Elixir & Go tracks and all have been incredibly beneficial, providing self-contained finite problems with which to learn the language. The Go language track has been wonderful in introducing me to the language, what idiomatic code is, and the many different ways in which one can solve a problem.",
  byline: "Rob Phoenix"
)
#https://avatars1.githubusercontent.com/u/9257284?v=4&s=460

Testimonial.create!(
  track: Track.find_by_slug!('elixir'),
  headline: "Self-contained finite problems with which to learn the language",
  content: "I have spent time with the Clojure, Elixir & Go tracks and all have been incredibly beneficial, providing self-contained finite problems with which to learn the language. The Go language track has been wonderful in introducing me to the language, what idiomatic code is, and the many different ways in which one can solve a problem.",
  byline: "Rob Phoenix"
)
#https://avatars1.githubusercontent.com/u/9257284?v=4&s=460

Testimonial.create!(
  track: Track.find_by_slug!('go'),
  headline: "Self-contained finite problems with which to learn the language",
  content: "I have spent time with the Clojure, Elixir & Go tracks and all have been incredibly beneficial, providing self-contained finite problems with which to learn the language. The Go language track has been wonderful in introducing me to the language, what idiomatic code is, and the many different ways in which one can solve a problem.",
  byline: "Rob Phoenix"
)
#https://avatars1.githubusercontent.com/u/9257284?v=4&s=460



