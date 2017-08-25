class RemoveContentType < ActiveRecord::Migration[5.1]
  def change
    remove_column :iteration_files, :content_type
  end
end
