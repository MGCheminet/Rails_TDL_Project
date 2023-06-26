class GastosController < ApplicationController
  before_action :set_grupo, only: [:new, :create]
  
  def index
    @gastos = Gasto.where(usuario_id: current_user.id)
  end
  
  def edit
    @gasto = Gasto.find(params[:id])
  end

  def new
    @gasto = @grupo.gastos.build
  end

  def update
    @gasto = Gasto.find(params[:id])
  
    if @gasto.update(gasto_params)
      redirect_to mis_gastos_path(id: cookies.signed[:usuario_id]), notice: 'El gasto fue actualizado correctamente.'
    else
      render :edit
    end
  end
  

  #def create
  #  @gasto = @grupo.gastos.build(gasto_params)
  #  @gasto.usuario_id = current_user.id
  #  @gasto.grupo_id = @grupo.id

  #  if @gasto.save
  #    flash[:notice] = 'Gasto agregado.'
  #    redirect_to @grupo
  #  else
  #    render :new
  #  end
  #end

  #Para que el creador del grupo pueda asignar gastos a cada persona
  #(El unico problema es que no los puede editar, solo puede eliminar los suyos)
  def create
    @grupo = Grupo.find(params[:grupo_id])
    @gasto = @grupo.gastos.build(gasto_params)
    @gasto.usuario_id = params[:gasto][:usuario_id] 
  
    if @gasto.save
      redirect_to @grupo, notice: 'Gasto agregado exitosamente.'
    else
      render :new
    end
  end
  
  

  def destroy
    @gasto = Gasto.find(params[:id])
    @gasto.destroy
    redirect_to mis_gastos_path(id: cookies.signed[:usuario_id]), notice: 'Gasto eliminado.'
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

