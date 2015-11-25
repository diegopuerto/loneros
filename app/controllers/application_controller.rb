class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include CanCan::ControllerAdditions

  before_action :configurar_parametros_permitidos, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
#    respond_to do |format|
 #     format.json { render nothing: true, status: :forbidden }
      render json: { errors: "Acceso restringido. Solo Administradores"  }, status: :unauthorized
  #  end
  end

  protected

    def configurar_parametros_permitidos
      devise_parameter_sanitizer.for(:sign_up) << :nombre
      devise_parameter_sanitizer.for(:sign_up) << :imagen
      devise_parameter_sanitizer.for(:sign_up) << :celular
      devise_parameter_sanitizer.for(:sign_up) << :nombre_marca
      devise_parameter_sanitizer.for(:sign_up) << :logo_marca
      devise_parameter_sanitizer.for(:sign_up) << :direccion
      devise_parameter_sanitizer.for(:account_update) << :nombre
      devise_parameter_sanitizer.for(:account_update) << :imagen
      devise_parameter_sanitizer.for(:account_update) << :celular
      devise_parameter_sanitizer.for(:account_update) << :nombre_marca
      devise_parameter_sanitizer.for(:account_update) << :logo_marca
      devise_parameter_sanitizer.for(:account_update) << :direccion
    end

    # in application_controller.rb
    def current_ability
      @current_ability ||= Ability.new(current_usuario)
    end
end
