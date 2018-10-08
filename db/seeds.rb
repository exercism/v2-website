ihid = User.create!(name: "Jeremy Walker", handle: 'iHiD', email: "jeremy@thalamus.ai", password: 'password', admin: true)
BootstrapUser.(ihid)

# Seed tracks
Git::SeedTracks.()

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
