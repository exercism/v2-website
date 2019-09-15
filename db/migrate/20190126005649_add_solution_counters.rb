class AddSolutionCounters < ActiveRecord::Migration[5.2]
  def change
    add_column :solutions, :num_comments, :smallint, null: false, default: 0
    add_column :solutions, :num_stars, :smallint, null: false, default: 0
  end
end
