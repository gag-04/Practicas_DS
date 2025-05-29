class Habitacion < ApplicationRecord
    self.table_name = 'habitacions'
    
    has_many :subhabitaciones, class_name: 'Habitacion', foreign_key: 'id_padre', dependent: :destroy
    belongs_to :padre, class_name: 'Habitacion', foreign_key: 'id_padre', optional: true


    def as_json(options = {})
        super(options.merge({ except: [:created_at, :updated_at] }))
    end
end
