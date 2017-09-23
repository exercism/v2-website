class Contributor < ApplicationRecord
  validates_presence_of :github_id, :github_username
end
