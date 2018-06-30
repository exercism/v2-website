class CreateMentors < ActiveRecord::Migration[5.1]
  def change
    create_table :mentors, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.belongs_to :track, foreign_key: true, null: false
      t.string :name, null: false
      t.string :avatar_url
      t.string :github_username, null: false
      t.string :link_text
      t.string :link_url
      t.text :bio

      t.timestamps
    end
  end
end
