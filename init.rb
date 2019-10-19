Redmine::Plugin.register :server_stats do
  name 'Server Stats plugin'
  author 'Rocco Mancin'
  description 'This is a simple plugin for Redmine to print stats about the server running Redmine.'
  version '0.0.1'


  permission :view_server_stats, { :serverstats => [:index] }

  menu :top_menu, :serverstats, { :controller => 'stats', :action => 'index' }, 
                  :caption => 'Server stats', 
                  :after => :projects, 
                  :if => Proc.new { User.current.allowed_to?(:view_server_stats, nil, :global => true) }



end



