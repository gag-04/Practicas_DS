class AddForeignKeyToHabitacions < ActiveRecord::Migration[8.0]
  def change
    # Agrega el índice y la clave foránea con ON DELETE CASCADE
    add_foreign_key :habitacions, :habitacions, column: :id_padre, on_delete: :cascade
    add_index :habitacions, :id_padre
  end
end
