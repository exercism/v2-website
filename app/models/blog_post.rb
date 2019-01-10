class BlogPost < ApplicationRecord
  extend FriendlyId
  friendly_id do |fid|
    fid.use [:history]
  end

  belongs_to :author, class_name: 'User', optional: true, foreign_key: 'author_handle', primary_key: 'handle'

  scope :published, -> { where('published_at <= NOW()') }
  scope :scheduled, -> { where('published_at > NOW()') }

  def self.categories
    BlogPost.published.distinct.pluck(:category).sort
  end

  def to_param
    slug
  end

  # TODO Temporary content
  # BlogPost.create(title: "Exercism in 2019", slug: "exercise-in-2019", author_handle: 'iHiD', published_at: DateTime.now, uuid: SecureRandom.uuid, marketing_copy: nil, content_repository: "blog", content_filepath: "posts/exercism-in-2019.md", category: 'interview')

  # TODO
  def content
<<-EOS
<p>2019 is here and we're really excited about what we're going to achieve with Exercism. I wanted just to outline a few high level things that are on our radar to give people an idea of what we're focussing on.</p>

<p>There are 4 key high-level objectives we have for this year:</p>

<ul>
<li>Make mentoring as fun and rewarding as possible</li>
<li>Improve a learner's journey with improved structure and more/better content.</li>
<li>Make a bigger deal of our community and highlighting people's huge contributions</li>
<li>Explore how we can expand Exercism (or build something in partnership to it) to reach total beginners</li>
</ul>

<p>Exercism is about to hit 250,000 members and is growing faster than ever. That means more solutions submitted, which could result in more pressure on mentors, slower response times, and more frustration for learners. We are also still currently only growing by word-of-mouth and trying to keep Exercism on the down-low. By the end of this year, we want to be close a point where we can shout about what we're doing and be able to cope with the demand. Even a small amount of marketing would realistically result in 50k submissions/day, which means we need excellent systems/people in place to cope. And we want to thrive, not just cope.</p>

<p>Achieving this is going to involve a mixture of clever technology (e.g. automatic analysis of solutions to recommend common improvements), tooling (e.g. mentor notes, cleverer mentor dashboard), content (e.g. articles on different approaches to a solution), expectation-management (e.g. estimated time to mentoring), community management (e.g. giving people a place to help get each other unstuck - forums?) and ensuring that our mentors/maintainers/contribute are energised by Exercism not burned out by it. And this in parallel with dealing with the 300 or so open issues that already exist :)</p>

<p>In order to manage all this, we need to take Exercism from being a website to being an organisation. We need people working on Exercism full-time and need money to spend on things like servers. We have started this process by incorporating Exercism as a non-for-profit company and applying for a handful of grants. We are planning to invest a lot of energy into getting this part really right, being super-transparent to the community, making sure people's voices are clearly heard, and building an organisation that we are really proud us.</p>

<p>One thing that we feel very strongly about is that we want to get there correctly more than we want to get there quickly. Exercism is a large, complex and ambitious project with dozens of repositories, over 3,000 contributors, and a complicated and long-term set of goals. In order to achieve its potential (and for us to not burn out on the way) we need to take the time to make the right decisions and to ensure that we carry everyone with us as we go. I know that sometimes things can feel slow and that seemingly easy solutions aren't implemented quickly but please know that that is not because we don't care, but because we care so much and so want to ensure we get things right.</p>

<p>Over the next few weeks, I'm going to be posting a few more updates about our near-future plans for how we address some of the things I've mentioned about. In the meantime, I just want to thank you for reading this and for being part of Exercism. We are passionate about giving people opportunity through learning and improving their programming skills, and we are so grateful you're here as part of this journey. Thank you! 💙</p>
EOS
  end
end
