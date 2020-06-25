require 'zip'

class ExportExperimentData
  include Mandate

  def call
    dir = Rails.root / "tmp" / "export_experiment_data" / "#{Time.now.to_i}-#{SecureRandom.uuid}"
    FileUtils.mkdir_p(dir)

    user_experiments.each do |user_experiment|
      next unless user_experiment.submissions.exists?
        
      ue_dir = dir / user_experiment.id.to_s
      FileUtils.mkdir_p(ue_dir)

      File.open(ue_dir / 'survey.json', "w+") { |f| f.write user_experiment.survey }

      user_experiment.solutions.includes(submissions: :test_run).each do |solution|
        solution_dir = ue_dir / solution.git_slug
        FileUtils.mkdir_p(solution_dir)

        File.open(solution_dir / "data.json", "w+") do |f| 
          f.write({ 
            initiated_at: solution.created_at,
            finished_at: solution.finished_at,
            difficulty_rating: solution.difficulty_rating
          }.to_json)
        end

        solution.submissions.each.with_index do |submission, submission_idx|
          submission_dir = solution_dir / submission_idx.to_s
          FileUtils.mkdir_p(submission_dir)

          File.open(submission_dir / "data.json", "w+") do |f| 
            f.write({ 
              submitted_at: submission.created_at,
              tests_status: submission.test_run.try(&:results_status),
              tests_results: submission.test_run.try(&:results),
              filenames: submission.files.map.with_index { |(filename, _), idx| [idx, filename]}.to_h
            }.to_json)
          end

          submission.files.each.with_index do |(filename, contents), file_idx|
            File.open(submission_dir / "#{file_idx}.#{File.extname(filename)}", "w+") do |f| 
              f.write(contents)
            end
          end
        end
      end
    end

    (dir / "archive.zip").tap do |zip_path|
      ZipDirectoryRecursively.(dir, zip_path)
    end
  end

  private
  memoize
  def user_experiments
    Research::UserExperiment.all.to_a
  end
end
