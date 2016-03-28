require 'lappen'
require 'pry'
require 'pry-stack_explorer'

# We need to require rails here in order to not get an
#
#   undefined method `env' for Rails:Module (NoMethodError)
#
# when Rails.env is called in 4.1.5.
require 'rails'

Dir['./spec/support/**/*.rb'].sort.each { |file| require file }

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.order = :random
  Kernel.srand(config.seed)

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = false
  end
end
