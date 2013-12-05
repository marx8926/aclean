Lean::Application.routes.draw do
  #devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}
  devise_for :users, :controllers => { :registrations => "registrations" }

  get "persona" => "ganar#index"
  post "persona_guardar" => "ganar#guardar_miembro"
  post "visita_guardar" => "ganar#guardar_visita"
  post "persona_editar_miembro" => "ganar#editar_miembro"
  post "persona_editar_visita" => "ganar#editar_visita"
  post "persona_eliminar_miembro" => "ganar#eliminar_miembro"


  post "persona_eliminar_visita/(:id)" => "ganar#eliminar_visita"
  get "recuperar_personas_inicio" => "ganar#recuperar_personas_inicio"
  get "recuperar_personas_filtrado/(:inicio)/(:fin)" => "ganar#recuperar_personas_filtro" , as: :recuperar_personas_filtro
  
  get "diezmos" => "diezmos#index"
  post "diezmos_guardar" => "diezmos#guardar"
  get "recuperar_diezmos_inicio" => "diezmos#recuperar_inicio"
  get "recuperar_diezmos_filtrado/(:inicio)/(:fin)" => "diezmos#recuperar_diezmo_filtro"

  get "ofrendas" => "ofrendas#index"
  post "ofrendas_guardar" => "ofrendas#guardar"
  get "recuperar_turno_inicio/(:id)" => "ofrendas#recuperar_turno", as: :recuperar_turnos
  get "recuperar_ofrendas_init" => "ofrendas#recuperar_init"
  get "recuperar_ofrendas_filtrado/(:inicio)/(:fin)" => "ofrendas#recuperar_ofrenda_filtro", as: :recuperar_ofrendas_filtro


  get "configuracion/servicios" => "configuracion#servicios"
  post "configuracion/guardar_servicio" => "configuracion#guardar_servicio"
  get "configuracion/recuperar_servicio" => "configuracion#recuperar_servicio"
  post "configuracion/editar_servicio" => "configuracion#editar_servicio"
  post "configuracion/drop_servicio" => "configuracion#drop_servicio"
  
  get "configuracion/usuario" => "configuracion#usuario"
  post "configuracion/guardar_usuario" => "configuracion#guardar_usuario"



  get "configuracion/lugar" => "configuracion#lugar"
  get "configuracion/recuperar_lugar" => "configuracion#recuperar_lugar"
  post "configuracion/guardar_lugar" => "configuracion#guardar_lugar"

  get "configuracion/datos_generales" => "configuracion#datos_generales"
  post "configuracion/guardar_datos_generales" => "configuracion#guardar_datos_generales"
  get "persona_servicio_complete" => "configuracion#personas_autocomplete"


  get "test" => "configuracion#test"
  get "asistencia" => "asistencia#index"
  post "asistencia_guardar" => "asistencia#guardar"
  get "recuperar_asistencia" => "asistencia#recuperar_init"
  get "recuperar_asistencia_filtrado/(:inicio)/(:fin)" => "asistencia#recuperar_filtro_asistencia"


  get "dashboard" => "informacion#index"
  get "data_miembro" => "informacion#chart_miembro"
  get "data_visitante" => "informacion#chart_visitante"
  get "data_pie" => "informacion#pie_chart_init"

  get "dashboard_diezmo" => "informacion#diezmo"
  get "dashboard_ofrenda" => "informacion#ofrenda"
  get "dashboard_membresia" => "informacion#membresia"
  get "dashboard_asistencia" => "informacion#asistencia"


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'ganar#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  #root "home#index"
  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
