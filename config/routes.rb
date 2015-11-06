Rails.application.routes.draw do
  #get 'precios/—no-controller-specs'

  mount_devise_token_auth_for 'Usuario', at: '/auth'

  resources :usuarios,
    except: [:edit, :new],
    defaults: { format: :json }  do

  resources :productos,
   except: [:edit, :new],
   defaults: { usuario_producto: true} do

    resources :precios,
      except: [:edit, :new]

    resources :caracteristicas,
      except: [:edit, :new]

    resources :imagenes,
      except: [:edit, :new]
	
    resources :categorias,
      only: [:index, :create, :destroy],
      defaults: { categoria_producto: true }
   end

    resources :pedidos,
      only: [:index],
      defaults: { usuario_pedido: true }
end

    resources :pedidos,
      except: [:edit, :new],
      defaults: { format: :json } 

     resources :productos,
      only: [:index, :show],
      defaults: { format: :json }

     resources :categorias,
       except: [:edit, :new],
       defaults: { format: :json }

  root 'pruebas#index'
end
