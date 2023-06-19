Rails.application.routes.draw do
  # Configura las rutas RESTful para el controlador Usuarios y automáticamente asigna las rutas a las acciones del controlador 
  
  post '/grupos/:id/agregar_usuario', to: 'grupos#agregar_usuario', as: :agregar_usuario
  
  get 'signup', to: 'usuarios#new'
  get 'login', to: 'sesiones#new', as: :login
  get 'logout', to: 'sesiones#destroy', as: :logout
  # post 'login', to: 'sesiones#create', as: :sesiones
  get '/home', to: 'home#index', as: :index_home
  get 'usuarios/:id/gastos', to: 'gastos#index', as: :mis_gastos
  
  
  resources :usuarios do
    resources :gastos, only: [:create]
    member do
      delete :delete_self
    end
  end

  get '/usuarios/:id', to: 'usuarios#show', as: :perfil
  
  resources :gastos
  
  resources :divisiones
  
  delete '/grupos/:id', to: "grupos#destroy", as: :borrar_grupo
  
  resources :sesiones, only: [:new, :create]


  resources :grupos do
    resources :gastos, only: [:new, :create]  
    post 'agregar_usuarios', on: :member
    #post 'dividir_gastos', on: :member
  end

  #Agregado por AGUSTIN
  get 'grupos/:grupo_id/dividir_gastos', to: 'divisiones#show', as: 'dividir_gastos_grupo'


  root 'inicio#index'  # Establece la página de inicio
end

