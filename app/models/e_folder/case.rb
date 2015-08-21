module EFolder
  class Case
    attr_reader :id

    def initialize(id)
      @id = id
    end

    def documents(force = false)
      if force
        @documents = nil
      end

      @documents ||= $vbms.send(VBMS::Requests::ListDocuments.new(self.id))
    end

    def get_nod(timestamp)
      # NOD Doc Type: 73
      get_document('73', timestamp)
    end

    def get_soc(timestamp)
      # SOC Doc Type: 95
      get_document('95', timestamp)
    end

    def get_ssoc(timestamp)
      # SSOC Doc Type: 97
      get_document('97', timestamp)
    end

    def get_form9(timestamp)
      # Form 9 Doc Type: 179
      get_document('179', timestamp)
    end

    def upload_form8(first_name, middle_init, last_name, file_name)
      path = (Rails.root + 'tmp' + 'forms' + file_name).to_s

      # Form 8 Doc Type: 178
      request = VBMS::Requests::UploadDocumentWithAssociations.new(@id, Time.now, first_name, middle_init, last_name, 'Form 8', path, '178', 'VACOLS', true)
      $vbms.send(request)
    end

    private

    def get_document(doc_type, timestamp)
      documents.detect{ |document| document.doc_type == doc_type && document.received_at == timestamp.to_date }
    end
  end
end
