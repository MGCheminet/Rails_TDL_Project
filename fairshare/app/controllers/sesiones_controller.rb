class SesionesController < ApplicationController
    def new
    end

    def create
        @usuario = Usuario.find_by(email: params[:email])

        if @usuario && @usuario.authenticate(params[:password])
            cookies.signed[:usuario_id] = @usuario.id
            redirect_to index_home_path
        else
            # Inicio de sesión inválido
            flash[:alert] = 'Nombre de usuario o contraseña inválidos'
            redirect_to login_path
        end
    end

    def destroy
        cookies.delete(:id_usuario)
        redirect_to root_url, notice: '¡Cierre de sesión exitoso!'
    end

end

  