class RemoveCommentFromReactions < ActiveRecord::Migration[5.2]
  def change
    return if Rails.env.production?

    remove_column :reactions, :comment
  end
end
