class CreateTestimonials < ActiveRecord::Migration[5.1]
  def change
    create_table :testimonials do |t|
      t.bigint :track_id, null: true
      t.string :headline, null: false
      t.text :content, null: false
      t.string :byline, null: false

      t.timestamps
    end

    add_foreign_key :testimonials, :tracks
  end
end
