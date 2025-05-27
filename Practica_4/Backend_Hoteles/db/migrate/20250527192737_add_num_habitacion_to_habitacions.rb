class AddNumHabitacionToHabitacions < ActiveRecord::Migration[8.0]
  def change
    add_column :habitacions, :num_Habitacion, :integer
  end
end
