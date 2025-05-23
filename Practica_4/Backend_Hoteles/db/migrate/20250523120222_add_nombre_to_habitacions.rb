class AddNombreToHabitacions < ActiveRecord::Migration[8.0]
  def change
    add_column :habitacions, :nombre, :string
  end
end
