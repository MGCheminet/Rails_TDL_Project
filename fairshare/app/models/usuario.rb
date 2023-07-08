class Usuario < ApplicationRecord
  acts_as_paranoid
  has_secure_password
  validates :nombre, presence: true
  validates :email, presence: true, uniqueness: true
  
  has_many :gastos   
  # has_many :splits, through: :gastos 
  has_many :grupos_usuarios, dependent: :destroy
  has_many :grupos, through: :grupos_usuarios

  def gasto_total_en_grupo(grupo)
    gastos.where(grupo_id: grupo.id).sum(:monto)
  end


  ["admin", "blocked"].each do |attribute|
    define_method "#{attribute}?" do
      send(attribute)
    end
  end


end
