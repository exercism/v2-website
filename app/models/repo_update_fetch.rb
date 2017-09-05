class RepoUpdateFetch < ApplicationRecord
  belongs_to :repo_update

  validates :repo_update, presence: true
  validates :host, presence: true
end
