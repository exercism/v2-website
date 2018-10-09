class EnsureThatMentorsRemainMentors < ActiveRecord::Migration[5.2]
  def change
    User.where(id: TrackMentorship.select(:user_id)).update_all(is_mentor: true)
  end
end
