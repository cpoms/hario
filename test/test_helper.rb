$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require "logger"
require "active_record"
require "hario"
require "models"

ActiveRecord::Base.configurations = YAML.load_file(File.join(File.dirname(__FILE__), 'database.yml'))
ActiveRecord::Base.establish_connection(ENV['DB'] || :sqlite3)
ActiveRecord::Migration.suppress_messages do
  load(File.join(File.dirname(__FILE__), "schema.rb"))
end

ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), "debug.log"))

require "active_support"
require "database_rewinder"

DatabaseRewinder[ENV['DB'] || 'sqlite3']
DatabaseRewinder.clean_all
require "fixtures"
require "hario_test_class"