class AddUuidToSubmissions < ActiveRecord::Migration[6.0]
  def change
    add_column :submissions, :uuid, :string, null: true
    Submission.find_each { |s| s.update(uuid: SecureRandom.uuid) }
    change_column_null :submissions, :uuid, false
  end
end
