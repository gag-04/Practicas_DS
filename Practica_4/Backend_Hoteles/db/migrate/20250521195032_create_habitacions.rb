class CreateHabitacions < ActiveRecord::Migration[8.0]
  def change
    create_table :habitacions do |t|
      t.integer :capacidad
      t.decimal :precio
      t.boolean :esta_ocupada
      t.boolean :nodo_hoja
      t.integer :id_padre

      t.timestamps
    end
  end
end
