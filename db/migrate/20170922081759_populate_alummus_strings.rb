class PopulateAlummusStrings < ActiveRecord::Migration[5.1]
  def up
    Maintainer.find_each do |maintainer|
      maintainer.update(alumnus: "alumnus") unless maintainer.active?
    end
  end

  def down
    Maintainer.update_all(alumnus: nil)
  end
end
