class Profile < ApplicationRecord
  belongs_to :user

  # TODO - We probably want to do some sort of
  # locking here to avoid a race.
  validates :slug, uniqueness: true

  def to_param
    slug
  end

  # TODO
  def avatar_url
    "http://lorempixel.com/400/400/"
  end
end
