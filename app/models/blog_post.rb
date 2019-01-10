class BlogPost < ApplicationRecord
  belongs_to :author, class_name: 'User', optional: true, foreign_key: 'author_handle', primary_key: 'handle'

  scope :published, -> { where('published_at <= NOW()') }
  scope :scheduled, -> { where('published_at > NOW()') }

  def to_param
    slug
  end
end
