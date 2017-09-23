class SetDefaultNumContributionsOnContributors < ActiveRecord::Migration[5.1]
  def change
    change_column_default :contributors, :num_contributions, 0
  end
end
