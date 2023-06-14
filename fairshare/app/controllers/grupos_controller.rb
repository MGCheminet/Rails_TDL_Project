class GruposController < ApplicationController
  before_action :set_grupo, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @grupos = current_user.grupos
  end

  def new
    @grupo = Grupo.new
    @usuarios = Usuario.where.not(id: current_user.id)
  end
  
  def create
    @grupo = Grupo.new(grupo_params)
    if @grupo.save
      usuario_agregar
      @grupo.usuarios << current_user
      redirect_to @grupo, notice: 'Grupo creado exitosamente.'
    else
      render :new
    end
  end

  def show
    @usuarios_grupo = @grupo.usuarios
  end

  def edit
    @usuarios = Usuario.where.not(id: current_user.id)
    @usuarios_grupo = @grupo.usuarios
  end

  def update
    if @grupo.update(grupo_params)
      redirect_to @grupo, notice: 'Grupo actualizado exitosamente.'
    else
      @usuarios = Usuario.where.not(id: current_user.id)
      render :edit
    end
  end

  def destroy
    if @grupo.destroy
      redirect_to grupos_path, notice: 'Grupo eliminado exitosamente.'
    else
      redirect_to @grupo, alert: 'El grupo no pudo ser eliminado.'
    end
  end

  def gasto_total_usuario(usuario)
    usuario.gastos.sum(:monto)
  end

  private

  def current_user
    usuario_id = cookies.signed[:usuario_id]
    @current_user ||= Usuario.find_by(id: usuario_id)
  end

  def set_grupo
    @grupo = Grupo.find(params[:id])
  end
  
  def usuario_agregar
    usuario_ids = params[:grupo][:id_usuarios] || []
    
    usuario_ids.each do |usuario_id|
      @grupo.grupos_usuarios.find_or_create_by(usuario_id: usuario_id)
    end
  end

  def grupo_params
    params.require(:grupo).permit(:nombre, :descripcion, id_usuarios: [])
  end

end

