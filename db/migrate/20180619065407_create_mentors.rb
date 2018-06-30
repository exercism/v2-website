class CreateMentors < ActiveRecord::Migration[5.1]
  def change
    create_table :mentors do |t|
      t.belongs_to :track, foreign_key: true, null: false
      t.string :name, null: false
      t.string :avatar_url
      t.string :github_username, null: false
      t.string :link_text
      t.string :link_url
      t.text :bio
    end
  end
end
