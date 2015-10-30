source 'https://rubygems.org'

gem 'rails', '~> 4.2.0'
gem 'puma'

gem 'activerecord-jdbc-adapter'
gem 'composite_primary_keys'
gem 'squeel'
gem 'sass-rails', '~> 4.0.3'
gem 'jbuilder', '~> 2.0'
gem 'pdf-forms', '~> 0.6.0'
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

# For SAML SSO

gem 'ruby-saml', '~> 1.1.0'
# TODO: Waiting on https://github.com/PracticallyGreen/omniauth-saml/pull/50 and
#                  https://github.com/PracticallyGreen/omniauth-saml/pull/62
gem 'omniauth-saml', git: 'https://github.com/alex/omniauth-saml', branch: 'patch-1'
gem 'omniauth-saml-va', git: 'https://github.com/department-of-veterans-affairs/omniauth-saml-va'

gem 'connect_vbms', path: './vendor/gems/connect_vbms'

group :development, :test do
  gem 'pry'
  gem 'pry-rails'

  gem 'brakeman'

  gem 'activerecord-jdbcsqlite3-adapter'
end
