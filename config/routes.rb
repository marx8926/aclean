Lean::Application.routes.draw do
  #devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}
  devise_for :users

  get "persona" => "ganar#index"
  post "persona_guardar" => "ganar#guardar_miembro"
  post "visita_guardar" => "ganar#guardar_visita"
  
  get "diezmos" => "diezmos#index"
  post "diezmos_guardar" => "diezmos#guardar"

  get "ofrendas" => "ofrendas#index"
  post "ofrendas_guardar" => "ofrendas#guardar"
  
  get "configuracion/servicios" => "configuracion#servicios"
  post "configuracion/guardar_servicio" => "configuracion#guardar_servicio"
  get "configuracion/lugar" => "configuracion#lugar"
  get "test" => "configuracion#test"

  get "asistencia" => "asistencia#index"
  post "asistencia_guardar" => "asistencia#guardar"
  

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
