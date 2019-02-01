class AddOnProfileAndAllowCommentsToSolutions < ActiveRecord::Migration[5.2]
  def change
    add_column :solutions, :show_on_profile, :boolean, null: false, default: false
    add_column :solutions, :allow_comments, :boolean, null: false, default: false
  end
end
