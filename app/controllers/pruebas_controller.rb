class PruebasController < ApplicationController
  def index
    @prueba = "Busumer API.\nLa fecha de hoy es: #{DateTime.now}"
    render json: @prueba
  end
end
