rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

resque_config = YAML.load_file(rails_root + '/config/resque.yml')
Resque.redis = resque_config[rails_env]

# Re-established dropped MySQL connections -- long-lived workers sometimes
# drop connections
Resque.after_fork = Proc.new {
  ActiveRecord::Base.verify_active_connections!
}

require 'resque/server'