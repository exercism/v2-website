class RetrieveMentorExerciseNotes
  include Mandate

  initialize_with(:track, :exercise)

  def call
    markdown = Git::WebsiteContent.head.mentor_notes_for(track.slug, exercise.slug)
    ParseMarkdown.(markdown.to_s)
  end
end
