class AddTipoToHabitacions < ActiveRecord::Migration[8.0]
  def change
    add_column :habitacions, :tipo, :string
  end
end
