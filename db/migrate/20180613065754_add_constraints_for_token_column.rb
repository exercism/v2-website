class AddConstraintsForTokenColumn < ActiveRecord::Migration[5.1]
  def change
    change_column_null :teams, :token, false
    add_index :teams, :token, unique: true
  end
end
