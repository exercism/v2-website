class BlogPost < ApplicationRecord
  extend FriendlyId
  friendly_id do |fid|
    fid.use [:history]
  end

  belongs_to :author, class_name: 'User', optional: true, foreign_key: 'author_handle', primary_key: 'handle'

  scope :published, -> { where('published_at <= NOW()') }
  scope :scheduled, -> { where('published_at > NOW()') }

  def to_param
    slug
  end

  def content
  end
end
