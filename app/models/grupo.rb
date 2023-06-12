class Grupo < ApplicationRecord
    attr_accessor :id_usuarios
    
    has_many :grupos_usuarios, dependent: :destroy
    has_many :usuarios, through: :grupos_usuarios  
    has_many :gastos
end
