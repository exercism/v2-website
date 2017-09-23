class DropColumnActiveFromMaintainers < ActiveRecord::Migration[5.1]
  def change
    remove_column :maintainers, :active, :boolean, default: true, null: false
  end
end
