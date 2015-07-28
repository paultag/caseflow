# $LOAD_PATH << Rails.root + '../' + 'connect_vbms' + 'src' + 'src'

require 'vbms'

$vbms = VBMS::Client.new(
    ENV['CONNECT_VBMS_URL'],
    ENV['CONNECT_VBMS_KEYFILE'],
    ENV['CONNECT_VBMS_SAML'],
    ENV['CONNECT_VBMS_KEY'],
    ENV['CONNECT_VBMS_KEYPASS'],
    ENV['CONNECT_VBMS_CACERT'],
    ENV['CONNECT_VBMS_CERT']
  )
