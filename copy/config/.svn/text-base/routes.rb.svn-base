ActionController::Routing::Routes.draw do |map|
  map.admin '/admin', :controller => 'admin_base', :action => 'index'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.resources :users, :member => {:my_groups => [:get], :my_favorites => [:get], :redemptions => [:get]}, :collection => {:experts => [:get],:link_user_accounts => [:get], :ask_details => [:get]}
  map.resources :profiles, :member => { :block_user => [:get], :unfollow_user => [:get], :list_followings => [:get], :list_followers => [:get], :my_requests => [:get], :decline_request => [:get], :ignore_request => [:get], :follow => [:get]  } 
  map.connect '/', :controller => 'home', :action => 'index'
  map.resource :session

  map.rss_feed '/rss_feed', :controller => 'rss_feed', :action => 'index'
  map.rss_feed '/design_rss', :controller => 'rss_feed', :action => 'design_rss'
  map.rss_feed '/learning_rss', :controller => 'rss_feed', :action => 'learning_rss'
  map.unsubscribe '/unsubscribe', :controller => 'users', :action => 'unsubscribe'
  map.reset_password '/reset_password', :controller => 'users', :action => 'reset_password'
  map.reset_password '/news_unsubscribe', :controller => 'users', :action => 'news_unsubscribe'
  map.reset_password '/news_subscribe', :controller => 'users', :action => 'news_subscribe'
  map.sitemap '/sitemap', :controller => 'home', :action => 'sitemap'  
  
  map.my_page '/my_page', :controller => 'profiles', :action => 'my_page'
  map.pointing_system '/pointing_system', :controller => 'users', :action => 'pointing_system'  
  map.recent_post '/recent_post', :controller => 'discussions', :action => 'index'
  map.learnings '/learnings', :controller => 'learnings', :action => 'index'
  map.comment_on_design '/comment_on_design', :controller => 'designs', :action => 'comment_on_design'
  map.comment_on_game '/comment_on_game', :controller => 'games', :action => 'comment_on_game'
  map.hot_discussions '/hot_discussions', :controller => 'discussions', :action => 'hot_discussions'
  map.top_designers '/top_designers', :controller => 'designs', :action => 'top_designers'
  map.recent_activity '/recent_activity', :controller => 'home', :action => 'recent_activity'
  map.experts '/experts', :controller => 'users', :action => 'experts'
  map.assets '/assets', :controller => 'learnings', :action => 'assets'
  map.report_abuse '/report_abuse', :controller => 'report_abuse', :action => 'report_abuse'
  map.resources :groups, :member => {:join => [:get],:unjoin=>[:get,:post], :members => [:get], :delete => [:get]}, :collection => { :get_more_activities => [:get]}
  map.connect 'designs/design/:permalink', :controller => 'designs', :action => 'design'
  map.connect 'learnings/learning/:permalink', :controller => 'learnings', :action => 'learning'  
#  map.connect 'events/details/:permalink', :controller => 'events', :action => 'details'  
  map.connect 'games/game/:permalink', :controller => 'games', :action => 'game'  
#  map.connect 'groups/show/:permalink', :controller => 'groups', :action => 'show'  
  map.connect 'news/news/:permalink', :controller => 'news', :action => 'news'  
  map.connect 'discussions/topic/:permalink', :controller => 'discussions', :action => 'topic'  
  map.connect 'profiles/show/:permalink', :controller => 'profiles', :action => 'show'    
  
  map.permalink 'group/:permalink', :controller => 'groups', :action => 'show'
  map.topic_link 'group/topic/:permalink', :controller => 'groups', :action => 'topic'
  map.connect 'group/:permalink.:format', :controller => 'groups', :action => 'show', :format => nil  
  
  map.privacy '/privacy',:controller=>"privacy",:action=>'index'
  map.aboutus '/aboutus',:controller=>"aboutus",:action=>'index'
  map.terms '/terms',:controller=>"terms",:action=>'index'
  #map.resources :design, :member => {:share_with_followers => [:post]}
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action
  
  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  
  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products
  
  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }
  
  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end
  
  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  
  # See how all your routes lay out with "rake routes"
  
  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.root :controller => 'home', :action => 'index'  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
