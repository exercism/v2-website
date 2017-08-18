class AddFileContentsDigestToIterationFiles < ActiveRecord::Migration[5.1]
  def up
    add_column :iteration_files, :file_contents_digest, :text, null: true

    IterationFile.find_each do |file|
      file.update(
        file_contents_digest: IterationFile.generate_digest(file.file_contents)
      )
    end

    change_column_null :iteration_files, :file_contents_digest, false
  end

  def down
    remove_column :iteration_files, :file_contents_digest
  end
end
