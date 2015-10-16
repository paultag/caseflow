# By default, OmniAuth will configure the path /auth/:provider. It is
# created by OmniAuth automatically for you, and you will start the auth
# process by going to that path.

if not ENV.has_key? 'SSOI_SAML_XML_LOCATION' or not ENV.has_key? 'SSOI_SAML_PRIVATE_KEY_LOCATION'
  raise 'SSOI_SAML_XML_LOCATION or SSOI_SAML_PRIVATE_KEY_LOCATION is not set'
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :samlva, 'CASEFLOW', ENV['SSOI_SAML_PRIVATE_KEY_LOCATION'], ENV['SSOI_SAML_XML_LOCATION'],
    :callback_path => '/caseflow/users/auth/saml/callback',
    :path_prefix => '/caseflow/auth'
end

Rails.application.config.login_url = "/caseflow/auth/samlva"
