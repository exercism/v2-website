class Profile < ApplicationRecord
  belongs_to :user

  def to_param
    user.handle
  end

  # TODO
  def avatar_url
    "http://lorempixel.com/400/400/"
  end
end
