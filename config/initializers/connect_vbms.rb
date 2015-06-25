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
    ENV['CONNECT_VBMS_URL'],
    ENV['CONNECT_VBMS_KEYFILE'],
    ENV['CONNECT_VBMS_SAML'],
    ENV['CONNECT_VBMS_KEY'],
    ENV['CONNECT_VBMS_KEYPASS'],
    ENV['CONNECT_VBMS_CACERT'],
    ENV['CONNECT_VBMS_CERT']
  ]
end

$vbms = VBMS::Client.new(*config)
