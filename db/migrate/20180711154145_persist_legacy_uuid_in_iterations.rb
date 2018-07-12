class PersistLegacyUuidInIterations < ActiveRecord::Migration[5.2]
  def change
    add_column :iterations, :legacy_uuid, :string, null: true
  end
end
