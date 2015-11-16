source 'https://rubygems.org'

gem 'rails', '~> 4.2.0'
gem 'puma'

gem 'activerecord-jdbc-adapter'
gem 'composite_primary_keys'
gem 'squeel'
gem 'sass-rails', '~> 5.0.0'
gem 'jbuilder', '~> 2.0'
gem 'pdf-forms', '~> 1.0.0'
gem 'kramdown'

gem 'sdoc', '~> 0.4.0', group: :doc

# Needed for asset compilation
gem 'therubyrhino'
gem 'uglifier', '>= 1.3.0'

# for reports
gem 'parallel', '~> 1.6.1'
gem 'ruby-progressbar', '~> 1.7.0'

gem 'nokogiri', '~> 1.6.6.2'
gem 'httpclient', '~> 2.6.0'

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
