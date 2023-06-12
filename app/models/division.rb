class Division < ApplicationRecord
    belongs_to :gasto
    belongs_to :usuario
    belongs_to :destinatario, class_name: 'Usuario'
end
