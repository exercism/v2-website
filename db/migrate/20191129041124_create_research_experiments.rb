class CreateResearchExperiments < ActiveRecord::Migration[6.0]
  def change
    create_table :research_experiments do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.string :repo_url, null: false

      t.timestamps
      t.index :slug
    end
  end
end
