class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.string :slug, null: false

      t.timestamps
    end

    add_index :teams, :slug, unique: true
  end
end
