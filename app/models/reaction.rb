class Reaction < ApplicationRecord
  belongs_to :solution
  belongs_to :user

  enum emotion: [ :love, :wowed, :applaud ]

  scope :with_comments, -> { where("comment != '' AND comment IS NOT NULL") }
end
