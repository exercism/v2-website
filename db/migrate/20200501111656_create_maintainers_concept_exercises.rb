class CreateMaintainersConceptExercises < ActiveRecord::Migration[6.0]
  def change
    create_table :maintainers_concept_exercises do |t|
      t.bigint :user_id, null: false
      t.integer :status, null: false, default: 0
      t.string :name, null: false

      t.string :issue_url
      t.text :introduction_content
      t.text :instructions_content
      t.text :example_content
      t.string :example_filename

      t.timestamps
    end
  end
end
