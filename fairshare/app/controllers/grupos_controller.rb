class GruposController < ApplicationController
  before_action :set_grupo, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    #@grupos = current_user.grupos
    if current_user
      @grupos = current_user.grupos
    else
      redirect_to login_path, alert: 'Debes iniciar sesión para ver los grupos.'
    end
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

    #@grupo = Grupo.find(params[:grupo_id])
    #@usuarios_grupo = @grupo.usuarios
    gasto_total_grupo = @grupo.gastos.sum(:monto)
    cantidad_integrantes = @usuarios_grupo.count

    @debe_recibe = @usuarios_grupo.each_with_object({}) do |usuario, hash|
      monto_puesto = @grupo.gastos.where(usuario_id: usuario.id).sum(:monto)
      monto_deber = [gasto_total_grupo / cantidad_integrantes - monto_puesto, 0].max

      monto_recibe = if monto_deber.zero?
                        monto_puesto - gasto_total_grupo/cantidad_integrantes
                     else
                       0 
                     end
      
      hash.merge!(usuario.id => { debe: monto_deber, recibe: monto_recibe })
    end

  end


  def edit
    @usuarios = Usuario.where.not(id: current_user.id)
    @usuarios_grupo = @grupo.usuarios
  end



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
    # Busco usuarios que ya estén asociados al grupo
    existing_users = @grupo.usuarios.to_a
  
    # Saco a todos los usuarios que no estén seleccionados del grupo
    unchecked_users = existing_users.reject { |usuario| usuario_ids.include?(usuario.id.to_s) }
    @grupo.usuarios.destroy(*unchecked_users) if unchecked_users.present?
  
    usuario_ids.each do |usuario_id|
      usuario = Usuario.find(usuario_id)
  
      # Si no están asociados, agrego usuarios al grupo
      @grupo.usuarios << usuario unless existing_users.include?(usuario)
    end
  
    # Agrega el usuario que crea el grupo si no está ya incluido, no es un admin y no es el mismo usuario que está modificando
    #unless existing_users.include?(current_user) || (current_user.admin? && current_user != @grupo.created_by)
      #@grupo.usuarios << current_user
      @grupo.usuarios << Usuario.find(@grupo.created_by)
    #end
  end
  
  
  

  
  def admin_grupos
    @grupos = Grupo.all
  end
    

  def destroy
    @grupo = Grupo.find(params[:id])
    if admin_user? || grupo_creator?
      @grupo.gastos.destroy_all
      @grupo.destroy
      flash[:notice] = 'Grupo eliminado correctamente.'
      if admin_user?
        redirect_to admin_grupos_grupos_path # Redirect to the admin grupos page
      else
        redirect_to grupos_path, notice: 'Grupo eliminado exitosamente.'
      end
    else
      flash[:alert] = 'No tienes permiso para eliminar este grupo.'
      redirect_to grupos_path # Redirect to a different path for non-admin and non-creator users
    end
  end

  #def destroy
  #  @grupo = Grupo.find(params[:id])
  
  #  if admin_user?
  #    @grupo.gastos.destroy_all
  #    @grupo.destroy
  #    redirect_to grupos_path, notice: "Group and expenses were successfully deleted."
  #  else
   #   redirect_to grupos_path, alert: "You are not authorized to perform this action."
   # end
  #end

  def gasto_total_usuario(usuario)
    usuario.gastos.sum(:monto)
  end
  
  private

  def current_user
    usuario_id = cookies.signed[:usuario_id]
    @current_user ||= Usuario.find_by(id: usuario_id)
  end

  def admin_user?
    current_user.admin?
  end

  #def grupo_creator?
  #  @grupo.creator == current_user
  #send

  def grupo_creator?
    @grupo.created_by == current_user.id
  end
  

  def set_grupo
    @grupo = Grupo.find(params[:id])
  end
  
  
  def grupo_params
    params.require(:grupo).permit(:nombre, :descripcion, id_usuarios: [])
  end

end

