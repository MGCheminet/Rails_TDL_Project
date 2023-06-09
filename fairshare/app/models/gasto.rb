class Gasto < ApplicationRecord 
    belongs_to :usuario
    belongs_to :grupo
    has_many :divisions
  end 
