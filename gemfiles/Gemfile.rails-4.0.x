source 'https://rubygems.org'

gem 'lappen', path: '..'
gem 'rails', '~> 4.0'

common_gemfile = Pathname.new(__dir__).join('Gemfile.common')
eval_gemfile(common_gemfile)
