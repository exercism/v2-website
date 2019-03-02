class UserEmailLog < ApplicationRecord
  belongs_to :user

  # In rails 6 we can use create_or_find_by for this
  def self.for_user(user)
    create!(user_id: user.id)
  rescue ActiveRecord::RecordNotUnique
    find_by(user_id: user.id)
  end
end
