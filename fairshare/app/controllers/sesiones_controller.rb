class SesionesController < ApplicationController
    def new
    end

    #def create
    #    @usuario = Usuario.find_by(email: params[:email])

    #    if @usuario && @usuario.authenticate(params[:password])
    #        cookies.signed[:usuario_id] = @usuario.id
    #        redirect_to index_home_path
    #    else
            # Inicio de sesión inválido
    #        flash[:alert] = 'Nombre de usuario o contraseña inválidos'
    #        redirect_to login_path
    #    end
    #end

    def create
        usuario = Usuario.find_by(email: params[:email])

        if usuario && usuario.authenticate(params[:password])
            if usuario.blocked?
            flash[:alert] = "Tu cuenta está bloqueada. Contacta al administrador."
            redirect_to login_path
            else
            # Log in the user
            cookies.signed[:usuario_id] = usuario.id
            redirect_to index_home_path
            end
        else
            flash.now[:alert] = "El correo electrónico o la contraseña son incorrectos."
            render :new
        end
    end

    def destroy
        cookies.delete(:usuario_id)
        redirect_to login_path, notice: 'Sesión cerrada.'
    end

end

  