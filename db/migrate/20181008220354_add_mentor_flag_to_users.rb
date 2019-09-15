class AddMentorFlagToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_mentor, :boolean, null: false, default: false
    User.where(id: TrackMentorship.distinct.select(:user_id)).
         update_all(is_mentor: true)
  end
end
