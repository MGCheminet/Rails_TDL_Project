#Ejemplo de Programación Funcional: show de grupos_controller.rb
def show
  @grupo = Grupo.find(params[:id])
  @usuarios_grupo = @grupo.usuarios

  gasto_total_grupo = @grupo.gastos.sum(:monto)
  cantidad_integrantes = @usuarios_grupo.count

  @debe_recibe = @usuarios_grupo.each_with_object({}) do |usuario, hash|
    monto_puesto = @grupo.gastos.where(usuario_id: usuario.id).sum(:monto)
    monto_deber = [gasto_total_grupo / cantidad_integrantes - monto_puesto, 0].max

    monto_recibe = if monto_deber.zero?
                     monto_puesto - gasto_total_grupo / cantidad_integrantes
                   else
                     0
                   end

    hash.merge!(usuario.id => { debe: monto_deber, recibe: monto_recibe })
  end
end

#Ejemplo de Programación Imperativa: Cómo estaba el show de grupos_controller.rb antes
def show
  @grupo = Grupo.find(params[:id])
  @usuarios_grupo = @grupo.usuarios

  #@grupo = Grupo.find(params[:grupo_id])
  #@usuarios_grupo = @grupo.usuarios
  gasto_total_grupo = @grupo.gastos.sum(:monto)
  cantidad_integrantes = @usuarios_grupo.count

  @debe_recibe = {}
  @usuarios_grupo.each do |usuario|
    monto_puesto = @grupo.gastos.where(usuario_id: usuario.id).sum(:monto)
    monto_deber = gasto_total_grupo / cantidad_integrantes - monto_puesto

    if monto_deber <= 0
      monto_recibe = monto_puesto - gasto_total_grupo / cantidad_integrantes
      monto_deber = 0
    else
      monto_recibe = 0
    end

    @debe_recibe[usuario.id] = { debe: monto_deber, recibe: monto_recibe }
  end

end

  

#Ejemplo de Atomicidad, manejo de errores y excepciones: create de usuarios_controller.rb
def create
<<<<<<< HEAD
  @usuario = Usuario.new(usuario_params)

  ActiveRecord::Base.transaction do
    if Usuario.exists?(email: @usuario.email)
      @usuario.errors.add(:email, 'El correo electrónico ya está registrado.')
      raise ActiveRecord::Rollback
    elsif @usuario.save
      flash[:notice] = 'Creación de usuario exitosa.'
      admin_user? ? redirect_to(index_home_path) : redirect_to(login_path)
    else
      raise ActiveRecord::Rollback
    end
  end

  if @usuario.errors.any?
    flash.now[:alert] = @usuario.errors.full_messages.join(' ')
    render action: "new"
  end
=======
    ActiveRecord::Base.transaction do
      @usuario = Usuario.new(usuario_params)
  
      if Usuario.exists?(email: @usuario.email)
        raise ActiveRecord::Rollback, 'El correo electrónico ya está registrado.'
      elsif @usuario.save
        flash[:notice] = 'Creación de usuario exitosa.'
        admin_user? ? redirect_to(index_home_path) : redirect_to(login_path)
      else
        raise ActiveRecord::Rollback, 'Error al crear el usuario. Las contraseñas no son idénticas.'
      end
    end
  
    rescue ActiveRecord::Rollback => e
      flash.now[:alert] = e.message
      render action: "new"
>>>>>>> 9fe4508bb75e9552ad722c583b2b4abdc9773b60
end
  
#Ejemplo de Metaprogramación
class User < ApplicationRecord
    ROLES = %w[admin]
  
    ROLES.each do |role|
      define_method "is_#{role}?" do
        self.role == role
      end
  
      validates_presence_of role.to_sym, if: "is_#{role}?"
    end
  end

<<<<<<< HEAD

#Modificación de User para usar metaprogramación
["admin", "blocked"].each do |attribute|
  define_method "#{attribute}?" do
    send(attribute)
  end
end

=======
>>>>>>> 9fe4508bb75e9552ad722c583b2b4abdc9773b60
#Ejemplo de Programación Procedural: CRUD para usuarios
#La programación procedural se enfoca en una secuencia de instrucciones 
#para realizar una tarea. Aunque Rails está diseñado en gran medida para 
#seguir el paradigma de programación orientada a objetos, todavía es posible 
#mostrar un ejemplo de programación procedural dentro de un proyecto de Rails. 
#A continuación se presenta un ejemplo de cómo se podría usar la programación 
#procedural en un controlador de Rails para realizar operaciones básicas en un modelo:

class UsersController < ApplicationController
    def index
      @users = User.all
    end
  
    def create
      user_params = params.require(:user).permit(:name, :email)
      user = create_user(user_params)
      if user
        redirect_to user_path(user.id), notice: 'Usuario creado exitosamente.'
      else
        flash.now[:alert] = 'No se pudo crear el usuario.'
        render :new
      end
    end
  
    def update
      user = User.find(params[:id])
      user_params = params.require(:user).permit(:name, :email)
      if update_user(user, user_params)
        redirect_to user_path(user.id), notice: 'Usuario actualizado exitosamente.'
      else
        flash.now[:alert] = 'No se pudo actualizar el usuario.'
        render :edit
      end
    end
  
    def destroy
      user = User.find(params[:id])
      if delete_user(user)
        redirect_to users_path, notice: 'Usuario eliminado exitosamente.'
      else
        redirect_to users_path, alert: 'No se pudo eliminar el usuario.'
      end
    end
  
    private
  
    def create_user(user_params)
      user = User.new(user_params)
      if user.save
        user
      else
        nil
      end
    end
  
    def update_user(user, user_params)
      if user.update(user_params)
        true
      else
        false
      end
    end
  
    def delete_user(user)
      if user.destroy
        true
      else
        false
      end
    end
  end
 
#En este ejemplo, el controlador UsersController muestra cómo se pueden 
#realizar operaciones básicas en un modelo User utilizando un enfoque 
#más procedural. Cada acción del controlador sigue una secuencia de 
#instrucciones para realizar las operaciones CRUD (crear, leer, actualizar, eliminar) en el modelo User.
#Si bien este ejemplo sigue utilizando los conceptos y estructuras de un 
#proyecto de Rails, se puede ver una aproximación más procedural en el flujo 
<<<<<<< HEAD
#de ejecución de las acciones y en la forma en que se manipulan los datos del modelo.

=======
#de ejecución de las acciones y en la forma en que se manipulan los datos del modelo.
>>>>>>> 9fe4508bb75e9552ad722c583b2b4abdc9773b60
