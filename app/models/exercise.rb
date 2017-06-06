class Exercise < ApplicationRecord
  belongs_to :track
  belongs_to :specification

  default_scope { includes :specification }

  def title
    specification.title
  end
end
