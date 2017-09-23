class FixMaintainersWithAlumnusFalse < ActiveRecord::Migration[5.1]
  def up
    Maintainer.where(alumnus: "0").update_all(alumnus: nil)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
