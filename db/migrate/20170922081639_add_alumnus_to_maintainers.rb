class AddAlumnusToMaintainers < ActiveRecord::Migration[5.1]
  def change
    add_column :maintainers, :alumnus, :string
  end
end
