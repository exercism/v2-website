class ClearUpLegacy < ActiveRecord::Migration[5.2]
  def change
    # Do this manually after deployment is checked to avoid data loss
    return if Rails.env.production?

    #drop_table :reactions
    #remove_column :solutions, :num_reactions
  end
end
