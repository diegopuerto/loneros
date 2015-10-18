class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :configurar_parametros_permitidos, if: :devise_controller?

  protected

    def configurar_parametros_permitidos
      devise_parameter_sanitizer.for(:sign_up) << :nombre
      devise_parameter_sanitizer.for(:sign_up) << :imagen
      devise_parameter_sanitizer.for(:sign_up) << :celular
      devise_parameter_sanitizer.for(:account_update) << :nombre
      devise_parameter_sanitizer.for(:account_update) << :imagen
      devise_parameter_sanitizer.for(:account_update) << :celular
    end
end
