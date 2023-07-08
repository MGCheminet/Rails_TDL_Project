class UsuariosController < ApplicationController
  # Se utiliza el callback before_action para configurar el método set_usuario, el cual se ejecuta antes 
  # de las acciones show, edit, update y destroy para buscar y configurar el objeto @usuario correspondiente
  protect_from_forgery with: :null_session
  before_action :set_usuario, only: [:show, :edit, :update, :destroy]
  

  def index
    @usuarios = Usuario.all
  end

  def new
    @usuario = Usuario.new
  end

  def create
    @usuario = Usuario.new(usuario_params)

    ActiveRecord::Base.transaction do
      if Usuario.exists?(email: @usuario.email)
        @usuario.errors.add(:email, 'El correo electrónico ya está registrado.')
      #flash.now[:alert] = 'El correo electrónico ya está registrado.'
      #render action: "new"
      raise ActiveRecord::Rollback
      elsif @usuario.save
        flash[:notice] = 'Creación de usuario exitosa.'
        admin_user? ? redirect_to(index_home_path) : redirect_to(login_path)
      else
        #@usuario.errors.add(:base, 'Mensaje de error')
        #flash.now[:alert] = 'Error al crear el usuario. Las contraseñas no son idénticas.'
        #render action: "new"
        raise ActiveRecord::Rollback
      end
    end

    if @usuario.errors.any?
      flash.now[:alert] = @usuario.errors.full_messages.join(' ')
      render action:"new"
    end

  end


  def show
  end

  def edit
  end

  def update
    if @usuario.update(usuario_params)
      flash[:notice] = 'Datos modificados.'
      redirect_to @usuario
    else
      flash[:alert] = 'Las contraseñas no son idénticas.'
      render :edit
    end
  end


  def destroy
    @usuario = Usuario.find(params[:id])
  
    if @usuario.admin?
      redirect_to index_home_url, notice: 'No se puede eliminar al usuario administrador.'
    else
  
      # Eliminar usuario
      @usuario.destroy
  
      if admin_user?
        redirect_to usuarios_path, notice: 'Usuario eliminado correctamente.'
      else
        session[:usuario_id] = nil
        redirect_to root_url, notice: 'Tu cuenta ha sido eliminada correctamente.'
      end
    end
  end


  def delete_self
    @usuario = current_user
    @usuario.destroy
  end

  def block_usuario
    @usuario = Usuario.find(params[:id])
    @usuario.update(blocked: true)
    redirect_to usuarios_path, notice: "Usuario bloqueado correctamente."
  end

  def unblock_usuario
    @usuario = Usuario.find(params[:id])
    @usuario.update(blocked: false)
    redirect_to usuarios_path, notice: "Usuario desbloqueado correctamente."
  end
  
  private

  def set_usuario
    @usuario = Usuario.find(params[:id])
  end

  def usuario_params
    params.require(:usuario).permit(:nombre, :email, :password, :password_confirmation)
  end

  def admin_user?
    current_user && current_user.admin?
  end

end
