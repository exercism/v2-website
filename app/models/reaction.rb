class Reaction < ApplicationRecord
  belongs_to :solution
  belongs_to :user

  enum emotion: [ :like, :love, :genius ]

  scope :with_comments, -> { where("comment != '' AND comment IS NOT NULL") }
end
