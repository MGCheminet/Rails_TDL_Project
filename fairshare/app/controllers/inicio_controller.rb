class InicioController < ApplicationController
    def index
        if current_user
            redirect_to index_home_path
        end
    end

private

def current_user
    usuario_id = cookies.signed[:usuario_id]
    @current_user ||= Usuario.find_by(id: usuario_id)
end
end
