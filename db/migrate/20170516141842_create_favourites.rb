class CreateFavourites < ActiveRecord::Migration[5.1]
  def change
    create_table :favourites do |t|
      t.bigint :iteration_id, null: false

      t.timestamps
    end

    add_foreign_key :favourites, :iterations
  end
end
