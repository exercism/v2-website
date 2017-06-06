class CreateExercises < ActiveRecord::Migration[5.1]
  def change
    create_table :exercises do |t|
      t.bigint :track_id, null: false
      t.bigint :specification_id, null: false

      t.boolean :core, default: false, null: false
      t.integer :position, null: false

      t.timestamps
    end

    add_foreign_key :exercises, :tracks
    add_foreign_key :exercises, :specifications
  end
end
