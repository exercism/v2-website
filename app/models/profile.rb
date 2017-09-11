class Profile < ApplicationRecord
  belongs_to :user

  def to_param
    user.handle
  end

  def has_external_links?
    website.present? || github.present? || twitter.present? ||
    linkedin.present? || medium.present?
  end
end
