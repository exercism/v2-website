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
        filename = iteration_file.filename.split("/").last
        File.open(solution_dir / filename, "w+") do |file|
          file << iteration_file.file_contents.force_encoding("utf-8")
        end
      end
    end

    (dir / "archive.zip").tap do |zip_path|
      ZipDirectoryRecursively.(dir, zip_path)
    end
  end
end
