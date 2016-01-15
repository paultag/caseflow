# $LOAD_PATH << Rails.root + '../' + 'connect_vbms' + 'src' + 'src'

require 'vbms'

class CaseflowLogger
  def log(event, data)
    case event
    when :request
      if data[:response_code] != 200
        Rails.logger.error "VBMS HTTP Error #{data[:response_code]} (#{data[:request].class.name}) #{data[:response_body]}"
      end
    end
  end
end

if $CASEFLOW_TEST_MODE
  $vbms = nil
else
  $vbms = VBMS::Client.from_env_vars(logger: CaseflowLogger.new, env_name: ENV["CONNECT_VBMS_ENV"])
end
