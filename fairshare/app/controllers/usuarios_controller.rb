class UsuariosController < ApplicationController
  # Se utiliza el callback before_action para configurar el método set_usuario, el cual se ejecuta antes 
  # de las acciones show, edit, update y destroy para buscar y configurar el objeto @usuario correspondiente
  before_action :set_usuario, only: [:show, :edit, :update, :destroy]

  def index
    @usuarios = Usuario.all
  end

  def new
    @usuario = Usuario.new
  end

  def create
    @usuario = Usuario.new(usuario_params)

    if Usuario.exists?(email: @usuario.email)
      flash.now[:alert] = 'El correo electrónico ya está registrado.'
      render action: "new"
    elsif @usuario.save
      flash[:notice] = 'Creación de usuario exitosa.'
      redirect_to index_home_path
    else
      @usuario.errors.add(:base, 'Mensaje de error')
      flash.now[:alert] = 'Error al crear el usuario. Por favor, corrige los siguientes errores:'
      render action: "new"
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
    @usuario.destroy
    redirect_to usuarios_url, notice: 'Usuario eliminado exitosamente.'
  end

  private

  def set_usuario
    @usuario = Usuario.find(params[:id])
  end

  def usuario_params
    params.require(:usuario).permit(:nombre, :email, :password, :password_confirmation)
  end


end
