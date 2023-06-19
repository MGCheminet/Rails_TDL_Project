Rails.application.routes.draw do
  # Configura las rutas RESTful para el controlador Usuarios y automáticamente asigna las rutas a las acciones del controlador 
  
  post '/grupos/:id/agregar_usuario', to: 'grupos#agregar_usuario', as: :agregar_usuario
  get 'signup', to: 'usuarios#new'
  get 'login', to: 'sesiones#new', as: :login
  get 'logout', to: 'sesiones#destroy', as: :logout
  # post 'login', to: 'sesiones#create', as: :sesiones
  get '/home', to: 'home#index', as: :index_home
  get 'usuarios/:id/gastos', to: 'gastos#index', as: :mis_gastos

  
  resources :grupos do
    collection do
      get 'admin_grupos', to: 'grupos#admin_grupos'
    end
  end
  
  resources :usuarios do
    member do
      delete :delete_self
      put :block, action: :block_usuario
      put :unblock, action: :unblock_usuario
    end
    resources :gastos, only: [:create]
  end

  get '/usuarios/:id', to: 'usuarios#show', as: :perfil
  
  resources :gastos
  
  resources :divisiones
  
  delete '/grupos/:id', to: "grupos#destroy", as: :borrar_grupo
  
  resources :sesiones, only: [:new, :create]


  resources :grupos do
    resources :gastos, only: [:new, :create]  
    post 'agregar_usuarios', on: :member
    post 'dividir_gastos', on: :member
  end
  
  root 'inicio#index'  # Establece la página de inicio
end

