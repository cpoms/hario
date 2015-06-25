$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require "active_record"
require "hario"
require "models"

ActiveRecord::Base.configurations = YAML.load_file(File.join(File.dirname(__FILE__), 'database.yml'))
ActiveRecord::Base.establish_connection(ENV['DB'] || :sqlite3)
load(File.join(File.dirname(__FILE__), "/schema.rb"))

ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")