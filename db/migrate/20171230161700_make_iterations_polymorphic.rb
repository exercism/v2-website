class MakeIterationsPolymorphic < ActiveRecord::Migration[5.1]
  def up
    add_column :iterations, :solution_type, :string, null: false, default: "Solution"
    remove_foreign_key :iterations, :solutions
  end

  def down
    remove_column :iterations, :solution_type
    add_foreign_key :iterations, :solutions
  end
end
