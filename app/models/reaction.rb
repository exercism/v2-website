class Reaction < ApplicationRecord
  belongs_to :solution
  belongs_to :user

  enum emotion: [ :like, :love, :genius ]
end
