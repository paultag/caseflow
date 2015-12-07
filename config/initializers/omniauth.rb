# By default, OmniAuth will configure the path /auth/:provider. It is
# created by OmniAuth automatically for you, and you will start the auth
# process by going to that path.

SPID = 'CASEFLOW'

if ENV.has_key?('SSOI_SAML_XML_LOCATION') && ENV.has_key?('SSOI_SAML_PRIVATE_KEY_LOCATION')
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :samlva, SPID, ENV['SSOI_SAML_PRIVATE_KEY_LOCATION'], ENV['SSOI_SAML_XML_LOCATION'],
      :callback_path => '/caseflow/users/auth/saml/callback',
      :path_prefix => '/caseflow/auth'
  end

  doc = Nokogiri.XML(File.open(ENV['SSOI_SAML_XML_LOCATION'], 'rb'))
  location = doc.xpath("//*[local-name()='SingleSignOnService']/@Location")[0].text

  # We do this because the VA SSOi Server doesn't like SAMLResponse when you
  # send it with an active IAMSESSION, so we'll always use this request to get
  # the server to send us a response.
  #
  # Worth making a few more attempts at having the server tolerate this behavior,
  # since it's already happy to issue it without an active SEESSION
  Rails.application.config.login_url = location + '?SPID=' + SPID
end
