class GenerateTokensForTeams < ActiveRecord::Migration[5.1]
  def up
    Team.find_each do |team|
      team.update!(token: SecureRandom::base58)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
