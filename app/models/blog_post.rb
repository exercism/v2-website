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
    markdown = case content_repository
      when "blog"
        Git::BlogRepository.head.blog_post(content_filepath)
      else
        # This will hit our bugsnag and we'll realise we've done something horribly
        # wrong in the blog.json quite quickly.
        raise "Unknown content repository for blog post #{blog_post.uuid}"
      end

    ParseMarkdown.(markdown.to_s)
  end
end
