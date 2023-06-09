class GruposController < ApplicationController
  before_action :set_grupo, only: [:show, :edit, :update, :destroy]

  def index
    usuario_id = cookies.signed[:usuario_id]
    @usuario = Usuario.find(usuario_id)
    @grupos = @usuario.grupos
  end

  def new
    @grupo = Grupo.new
    @usuarios = Usuario.all
  end

  def create
    @grupo = Grupo.new(grupo_params)
    if @grupo.save
      usuario_agregar
      redirect_to @grupo, notice: 'Grupo creado exitosamente.'
    else
      @usuarios = Usuario.all
      render :new
    end
  end

  def show
    @usuarios_grupo = @grupo.usuarios
  end

  def edit
    @usuarios = Usuario.all
    @usuarios_grupo = @grupo.usuarios
  end

  def update
    if @grupo.update(grupo_params)
      redirect_to @grupo, notice: 'Grupo actualizado exitosamente.'
    else
      @usuarios = Usuario.all
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

  def set_grupo
    @grupo = Grupo.find(params[:id])
  end

  def grupo_params
    params.require(:grupo).permit(:nombre, :descripcion)
  end

  def usuario_agregar
    usuario_ids = params[:grupo][:id_usuarios] || []
    
    usuario_ids.each do |usuario_id|
      @grupo.grupos_usuarios.find_or_create_by(usuario_id: usuario_id)
    end
  end
end
