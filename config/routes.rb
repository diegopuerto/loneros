Rails.application.routes.draw do
  #get 'precios/—no-controller-specs'

  mount_devise_token_auth_for 'Usuario', at: '/auth'

  resources :usuarios,
    except: [:edit, :new],
    defaults: { format: :json }

  resources :productos,
   except: [:edit, :new],
   defaults: { format: :json } do

    resources :precios,
      except: [:edit, :new],
      defaults: { format: :json }

    resources :caracteristicas,
      except: [:edit, :new],
      defaults: { format: :json }

    resources :imagenes,
      except: [:edit, :new],
      defaults: { format: :json }
	
    resources :categorias,
      only: [:index, :create, :destroy],
      defaults: { categoria_producto: true }

   end

     resources :categorias,
       except: [:edit, :new],
       defaults: { format: :json }

  root 'pruebas#index'
end
