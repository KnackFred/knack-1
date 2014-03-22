KnackRegistry::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  root :to => "registrant#home"

  match 'signin' => "registrant#login"
  match 'signout' => "registrant#logout"
  match 'signup' => "registrant#register"
  match 'give' => "registrant#give"

  match 'profile' => "registrant#profile"
  match 'transactions' => "registrant#viewall"
  match 'addgift' => "registrant#addgift"
  match 'links' => "registrant#links"
  match 'manage_registry' => "registrant#manage_registry"
  match 'invite_friends' => "follows#index"
  match 'fetch_fb_cross_friends' => "registrant#fetch_fb_cross_friends"
  match 'invited_signup' => 'registrant#invited_signup'

  match 'purchased' => redirect("/manage_registry")
  match 'wishlist' => redirect("/manage_registry")
  match 'ordered' => redirect("/manage_registry")

  match 'add_to_cart/:id' => "registrant#add_to_cart"
  match 'registrant/exchange/:id' => "registrant#exchange"

  match 'toolbars' => 'registrant#downloadtool'
  match 'add_my_gift' => 'registrant#addmyowngift', :as => 'add_my_gift'
  match 'use_toolbar' => 'registrant#how_use_toolbar'
  match 'calculate_tax' => 'registrant#calculate_tax'
  match 'delete_registry_item/:id' => 'registrant#delete_registry_item', :as => 'delete_registry_item'
  match 'edit_registry_item/:id' => 'registrant#edit_registry_item', :as => 'edit_registry_item'
  match 'add_from_registry/:id' => 'registrant#add_from_registry', :as => 'add_from_registry'


  # HOME
  match 'home' => redirect("/")
  match 'home2' => redirect("/")
  match 'home3' => redirect("/")
  match 'registrant/home' => redirect("/")
  match 'registry/:id' => 'registrant#registry', :as => 'registry'
  match 'catalog(/:id)' => 'browse#catalog', :as => 'catalog'
  match 'hot(/:site)' => 'browse#feed', :as => 'feed'

  # CHECKOUT
  match 'cart' => "payment#cart"
  get   'select_payment_method' => 'payment#select_payment_method'
  get   'pay_via_check' => 'payment#pay_via_check'
  get   'pay_via_venmo' => 'payment#pay_via_venmo'
  post  'make_payment_via_venmo' => 'payment#make_payment_via_venmo'
  match 'step1(/:id)' => "payment#step1", :as => "step1"
  match 'step2(/:id)' => "payment#step2", :as => 'step2'
  match 'step3' => "payment#step3"
  match 'process_order' => "payment#process_order"
  match 'success_payment/:guid' => "payment#success_payment", :as => "success_payment"
  match 'error_payment/:message' => "payment#error_payment", :as => "error_payment"
  match 'payment_interrupted' => "payment#payment_interrupted", :as => "payment_interrupted"

  # ITEM
  scope 'item' do
    match ':c/:id(/:item_name)' => 'browse#item', :as => 'from_catalog'
    match ':r/:r2p/:id(/:item_name)' => 'browse#item', :as => 'from_registry'
  end

  # BRANDS
  match 'brands' => 'browse#brands'
  match 'brand/:valparam' => 'browse#catalog', :defaults => {:param => "b"}, :as => 'brand'
  match 'brand/:b/:id' => 'browse#item', :as => 'from_brand'

  # STORES
  match 'stores' => 'browse#stores'
  match 'store/:valparam' => 'browse#catalog', :defaults => {:param => "s"}, :as => 'store'
  match 'store/:s/:id' => 'browse#item', :as => 'from_store'

  # Local Sites
  match 'sf' => redirect("/sanfrancisco")
  match 'san_francisco' => redirect("/sanfrancisco")
  match 'sanfrancisco' => 'info#san_francisco'

  match 'info/sample_registry' => redirect("/sample_registry")
  match 'sample_registry' => 'registrant#registry', :defaults => {:id => 644}

  match 'info/howdoeswork' => redirect("/info/tour")

  resources :follows, :only => [:index, :create, :destroy, :follow_fb_friends]

  namespace :admin do
    resources :products, :except => :destroy do
      member do
        get :image
        put :image
      end
    end
    resources :partner_administrators do
      member do
        get :delete
      end
    end
  end
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  match ':controller(/:action(/:id))'
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'

end
