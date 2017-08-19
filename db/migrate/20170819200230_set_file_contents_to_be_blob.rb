class SetFileContentsToBeBlob < ActiveRecord::Migration[5.1]
  def change
    change_column :iteration_files, :file_contents, :blob, null: false
  end
end
