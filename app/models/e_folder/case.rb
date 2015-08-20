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

      @documents ||= $vbms.send(VBMS::Requests::ListDocuments.new(self.id)).map do |doc|
        Document.new(
          doc.document_id.try(:value),
          doc.filename.try(:value),
          doc.doc_type.try(:value),
          doc.source.try(:value),
          doc.received_at
        )
      end
    end

    def get_nod(timestamp)
      get_document(['Notice of Disagreement'], timestamp)
    end

    def get_soc(timestamp)
      get_document(['Statement of Case (SOC)'], timestamp)
    end

    def get_ssoc(timestamp)
      get_document(['Supplemental Statement of Case (SSOC)'], timestamp)
    end

    def get_form9(timestamp)
      get_document(['VA Form 9, Appeal to Board of Veterans Appeals'], timestamp)
    end

    def get_other(names, timestamp)
      get_document(names, timestamp)
    end

    def upload_form8(first_name, middle_init, last_name, file_name)
      path = (Rails.root + 'tmp' + 'forms' + file_name).to_s

      request = VBMS::Requests::UploadDocumentWithAssociations.new(@id, Time.now, first_name, middle_init, last_name, 'Form 8', path, '178', 'VACOLS', true)
      $vbms.send(request)
    end

    private

    def get_document(names, timestamp)
      documents.detect{ |i| names.include?(i.type.try(:description)) && i.received_at == timestamp.to_date }
    end
  end
end
