class DivisionesController < ApplicationController
    def show
      @grupo = Grupo.find(params[:grupo_id])
      @usuarios_grupo = @grupo.usuarios
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
  end