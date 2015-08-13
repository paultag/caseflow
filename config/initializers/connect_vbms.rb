# $LOAD_PATH << Rails.root + '../' + 'connect_vbms' + 'src' + 'src'

require 'vbms'

$vbms = VBMS::Client.from_env_vars(env_name: ENV["CONNECT_VBMS_ENV"])
