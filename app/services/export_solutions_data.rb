require 'zip'

class ExportSolutionsData
  include Mandate

  initialize_with :solutions

  def call
    dir = Rails.root / "tmp" / "export_solutions_data" / "#{Time.now.to_i}-#{SecureRandom.uuid}"
    FileUtils.mkdir_p(dir)

    solutions.includes(iterations: :files).each.with_index do |solution, idx|
      solution_dir = dir / idx.to_s
      FileUtils.mkdir(solution_dir)

      solution.iterations.first.files.each do |iteration_file|
        File.open(solution_dir / iteration_file.filename, "w+") do |file|
          file << iteration_file.file_contents
        end
      end
    end

    (dir / "archive.zip").tap do |zip_path|
      ZipDirectoryRecursively.(dir, zip_path)
    end
  end
end
