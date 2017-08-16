class Iteration < ApplicationRecord
  belongs_to :solution
  has_many :files, class_name: "IterationFile"
  has_many :discussion_posts
  has_many :notifications, as: :about

  enum mentor_status: [:pending, :reply, :refactor, :approved]

  def files_to_display
    @files_to_display ||= begin
      exercise_slug = solution.exercise.slug
      track_url = solution.exercise.track.repo_url
      exercise_reader = solution.exercise.track.repo.exercise(exercise_slug)
      filenames_to_ignore = exercise_reader.files

      fs = []
      files.each do |file|
        fs << file unless filenames_to_ignore.include?(file.filename)
      end
      fs
    end
  end
end
