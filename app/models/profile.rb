class Profile < ApplicationRecord
  belongs_to :user

  def to_param
    user.handle
  end
end
