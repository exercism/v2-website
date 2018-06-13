class AddTokenToTeam < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :token, :string
  end
end
