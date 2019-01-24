class BlogPost < ApplicationRecord
  extend FriendlyId
  friendly_id do |fid|
    fid.use [:history]
  end

  belongs_to :author, class_name: 'User', optional: true, foreign_key: 'author_handle', primary_key: 'handle'
  has_many :comments, class_name: "BlogComment", dependent: :destroy

  scope :published, -> { where('published_at <= ?', Time.current) }
  scope :scheduled, -> { where('published_at > ?', Time.current) }
  scope :ordered_by_recency, -> { order('published_at DESC') }

  def self.categories
    BlogPost.published.distinct.pluck(:category).sort
  end

  def self.categories_with_counts
    BlogPost.published.group(:category).count.sort_by { |cat,_| cat }
  end

  def to_param
    slug
  end

  def content
    markdown = case content_repository
      when "blog"
        Git::BlogRepository.head.blog_post_content(content_filepath)
      else
        # This will hit our bugsnag and we'll realise we've done something horribly
        # wrong in the blog.json quite quickly.
        raise "Unknown content repository for blog post #{uuid}"
      end

    ParseMarkdown.(markdown.to_s)
  end
end
