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
    @grupo.created_by = current_user.id

    if @grupo.save
      usuario_ids = params[:grupo][:id_usuarios] || []
      usuario_ids << current_user.id

      valid_usuario_ids = usuario_ids.compact.select { |id| Usuario.exists?(id) }
      @grupo.usuarios << Usuario.find(valid_usuario_ids)     
      #@grupo.usuarios << Usuario.find(usuario_ids)
      
      flash[:notice] = 'Grupo creado exitosamente.'
      redirect_to grupos_path
    else
      flash.now[:alert] = 'Error al crear el grupo.'
      render :new
    end
  end

  def show
    @grupo = Grupo.find(params[:id])
    @usuarios_grupo = @grupo.usuarios
  end
  

  def edit
    @usuarios = Usuario.where.not(id: current_user.id)
    @usuarios_grupo = @grupo.usuarios
  end

  #def update
  #  if @grupo.update(grupo_params)
  #    redirect_to @grupo, notice: 'Grupo actualizado exitosamente.'
  #  else
  #    @usuarios = Usuario.where.not(id: current_user.id)
  #    render :edit
  #  end
  #end

  def update
    usuario_ids = params[:grupo][:id_usuarios] || []
  
    if @grupo.update(grupo_params)
      modificar_usuarios(usuario_ids)
      redirect_to @grupo, notice: 'Grupo actualizado exitosamente.'
    else
      @usuarios = Usuario.where.not(id: current_user.id)
      render :edit
    end
  end
  
  def modificar_usuarios(usuario_ids)
    # Find the existing users associated with the group
    existing_users = @grupo.usuarios.to_a
    
    # Add the creator of the group if not already in the group
    @grupo.usuarios << current_user unless existing_users.include?(current_user)
    
    # Iterate over the selected user IDs
    usuario_ids.each do |usuario_id|
      usuario = Usuario.find(usuario_id)
      
      # Add the user to the group if they are not already associated
      @grupo.usuarios << usuario unless existing_users.include?(usuario)
      
      # Remove the user from the existing users list to track which users should remain associated
      existing_users.delete(usuario)
    end
    
    # Remove any remaining users from the group who were unchecked
    existing_users.each do |usuario|
      @grupo.usuarios.delete(usuario)
    end
  end
  
    
  
  


  def destroy
    if @grupo.gastos.destroy_all && @grupo.destroy      
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
  

  #def usuario_agregar
  #  usuario_ids = params[:grupo][:id_usuarios] || []
  #  usuario_ids.each do |usuario_id|
  #    @grupo.usuarios << Usuario.find(usuario_id)
  #  end
  #  redirect_to @grupo, notice: 'Usuarios agregados al grupo exitosamente.'
  #end
  

  def grupo_params
    params.require(:grupo).permit(:nombre, :descripcion, id_usuarios: [])
  end

end

