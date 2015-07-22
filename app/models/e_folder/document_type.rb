module EFolder
  class DocumentType
    attr_reader :id, :description

    class << self
      def init!(force = false)
        if force
          @data = nil
        end
        @data = $vbms.send(VBMS::Requests::GetDocumentTypes.new)
      end

      def find(id)
        type = @data.detect {|i| i.type_id == id.to_s || i.type_id == id.to_s.gsub(/^0+/, '') }

        if type.present?
          self.new(id, type.description)
        else
          nil
        end
      end
    end

    def initialize(id, description)
      @id = id
      @description = description
    end
  end
end

EFolder::DocumentType.init!
