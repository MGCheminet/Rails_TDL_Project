class GastosController < ApplicationController
  before_action :set_grupo, only: [:new, :create]

  def new
    @gasto = @grupo.gastos.build
  end

  def create
    @gasto = @grupo.gastos.build(gasto_params)
    @gasto.usuario_id = current_user.id
    @gasto.grupo_id = @grupo.id

    if @gasto.save
      flash[:notice] = 'Gasto agregado.'
      redirect_to @grupo
    else
      render :new
    end
  end

  private

  def set_grupo
    @grupo = Grupo.find(params[:grupo_id])
  end

  def current_user
    usuario_id = cookies.signed[:usuario_id]
    @current_user ||= Usuario.find_by(id: usuario_id)
  end

  def gasto_params
    params.require(:gasto).permit(:monto, :descripcion, :fecha)
  end
end

