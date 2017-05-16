class CreateFavourites < ActiveRecord::Migration[5.1]
  def change
    create_table :favourites do |t|
      t.bigint :submission_id, null: false

      t.timestamps
    end

    add_foreign_key :favourites, :submissions
  end
end
