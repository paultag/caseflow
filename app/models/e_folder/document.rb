module EFolder
  class Document
    attr_reader :id, :filename, :type, :source, :received_at

    def initialize(id, filename, type_id, source, received_at)
      @id = id
      @filename = filename
      @type = DocumentType.find(type_id)
      @source = source
      @received_at = received_at
    end
  end
end
