class Usuario < ApplicationRecord
  has_secure_password
  attr_accessor :email
  validates :nombre, presence: true
  validates :email, presence: true, uniqueness: true
  
  has_many :gastos   
  # has_many :splits, through: :gastos 
  has_many :grupos_usuarios, dependent: :destroy
  has_many :grupos, through: :grupos_usuarios

  def gasto_total_en_grupo(grupo)
    gastos.where(grupo_id: grupo.id).sum(:monto)
  end
  
end
