source 'https://rubygems.org'

ruby '2.0.0', engine: 'jruby', engine_version: '1.7.22'
# This next line tricks RVM (as seen on our servers) into doing the right thing.
#ruby=jruby-1.7.22

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.1.8'
gem 'puma'

gem 'activerecord-jdbc-adapter'
gem 'composite_primary_keys'
gem 'squeel'
gem 'sass-rails', '~> 4.0.3'
gem 'jbuilder', '~> 2.0'
gem 'pdf-forms', '0.6.0'
gem 'kramdown'

gem 'sdoc', '~> 0.4.0', group: :doc

# Needed for asset compilation
gem 'therubyrhino'
gem 'uglifier', '>= 1.3.0'

# for the idenitfy_cases script
gem 'parallel', '~> 1.6.1'

# for vbms_connect
gem 'httpi'
# gem 'libxml-jruby'
gem 'nokogiri', '~> 1.6.6.2'

gem 'connect_vbms', path: './vendor/gems/connect_vbms'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'pry'
  gem 'pry-rails'

  gem 'brakeman'

  gem 'activerecord-jdbcsqlite3-adapter'
end
