class AddFilenamesToSubmissions < ActiveRecord::Migration[6.0]
  def change
    add_column :submissions, :filenames, :json, null: true
    #Submission.update_all(filenames: [])
    change_column_null :submissions, :filenames, false
  end
end
