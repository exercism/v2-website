class CreateResearchUserExperiments < ActiveRecord::Migration[6.0]
  def change
    create_table :research_user_experiments do |t|
      t.bigint :user_id
      t.bigint :experiment_id

      t.timestamps

      t.foreign_key :users
      t.foreign_key :research_experiments, column: :experiment_id
      t.index [:user_id, :experiment_id], unique: true
    end
  end
end
