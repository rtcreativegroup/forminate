require 'bundler/setup'
require 'forminate'

require 'active_record'
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)
ActiveRecord::Schema.define do
  suppress_messages do
    create_table :dummy_users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
    end
  end
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.filter_run_excluding broken: true
  config.run_all_when_everything_filtered = true
end

# Requires supporting files in spec/support/
Dir["#{File.dirname(__FILE__)}/support/*.rb"].each { |file| require file }
