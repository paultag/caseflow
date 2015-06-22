$LOAD_PATH << Rails.root + 'vendor' + 'connect_vbms' + 'src'

require 'vbms'

# require Rails.root + 'vendor' + 'connect_vbms' + 'src' + 'vbms'

config = case ENV['CONNECT_VBMS_ENV']
when 'uat'
  [
    ENV['CONNECT_VBMS_URL_UAT'],
    ENV['CONNECT_VBMS_KEYFILE_UAT'],
    ENV['CONNECT_VBMS_SAML_UAT'],
    ENV['CONNECT_VBMS_KEY_UAT'],
    ENV['CONNECT_VBMS_KEYPASS_UAT'],
    ENV['CONNECT_VBMS_CACERT_UAT'],
    ENV['CONNECT_VBMS_CERT_UAT']
  ]
else
  [
    ENV['CONNECT_VBMS_URL_TEST'],
    ENV['CONNECT_VBMS_KEYFILE_TEST'],
    ENV['CONNECT_VBMS_SAML_TEST'],
    nil,
    ENV['CONNECT_VBMS_KEYPASS_TEST'],
    nil,
    nil
  ]
end

$vbms = VBMS::Client.new(*config)
