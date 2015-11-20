require 'active_record'

Product = Class.new(ActiveRecord::Base)

RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

    ActiveRecord::Schema.define do
      self.verbose = false
      create_table(:products, force: true) { |t| t.integer(:price) }
    end
  end

  config.after(:suite) do
    Object.send(:remove_const, :Product)
    ActiveRecord::Base.connection.disconnect!
  end
end
