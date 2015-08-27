module EFolder
  class Case
    attr_reader :id

    SOC_DOC_TYPE_ID = '95'
    NOD_DOC_TYPE_ID = '73'
    SSOC_DOC_TYPE_ID = '97'
    FORM_9_DOC_TYPE_ID = '179'
    FORM_8_DOC_TYPE_ID = '178'

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
      get_document(NOD_DOC_TYPE_ID, timestamp)
    end

    def get_soc(timestamp)
      get_document(SOC_DOC_TYPE_ID, timestamp)
    end

    def get_ssoc(timestamp)
      get_document(SSOC_DOC_TYPE_ID, timestamp)
    end

    def get_form9(timestamp)
      get_document(FORM_9_DOC_TYPE_ID, timestamp)
    end

    def upload_form8(first_name, middle_init, last_name, file_name)
      path = (Rails.root + 'tmp' + 'forms' + file_name).to_s

      request = VBMS::Requests::UploadDocumentWithAssociations.new(@id, Time.now, first_name, middle_init, last_name, 'Form 8', path, FORM_8_DOC_TYPE_ID, 'VACOLS', true)
      $vbms.send(request)
    end

    private

    def get_document(doc_type, timestamp)
      documents.detect{ |document| document.doc_type == doc_type && document.received_at == timestamp.to_date }
    end
  end
end
