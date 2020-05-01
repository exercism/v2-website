class Maintainers::ConceptExercise < ApplicationRecord
  enum status: [:pending, :submitted]

  belongs_to :user

  def introduction_html
    ParseMarkdown.(introduction_content)
  end

  def instructions_html
    ParseMarkdown.(instructions_content)
  end

  def submit!
    update(status: :submitted)
  end
end
