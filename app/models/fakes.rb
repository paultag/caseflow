module Caseflow
  module Fakes
    class Case
      attr_reader :bfkey, :bfcorlid, :bfac, :bfmpro, :efolder_appellant_id, :appeal_type, :folder

      def self.find(bfkey)
        return Caseflow::Fakes::DATA[bfkey]
      end

      def initialize(bfkey, bfcorlid, bfac, bfmpro, bfdnod, bfd19, bfdsoc,
                     efolder_nod, efolder_form9, efolder_soc,
                     efolder_appellant_id, appeal_type, folder)
        @bfkey = bfkey
        @bfcorlid = bfcorlid
        @bfac = bfac
        @bfmpro = bfmpro

        @bfdnod = bfdnod
        @bfd19 = bfd19
        @bfdsoc = bfdsoc

        @efolder_nod = efolder_nod
        @efolder_form9 = efolder_form9
        @efolder_soc = efolder_soc

        @efolder_appellant_id = efolder_appellant_id
        @appeal_type = appeal_type

        @folder = folder
      end

      _DATE_FIELDS = [
        :bfdnod, :bfd19, :bfdsoc, :bfssoc1, :bfssoc2, :bfssoc3, :bfssoc4,
        :bfssoc5, :efolder_nod, :efolder_form9, :efolder_soc, :efolder_ssoc1,
        :efolder_ssoc2, :efolder_ssoc3, :efolder_ssoc4, :efolder_ssoc5
      ]
      _DATE_FIELDS.each do |field|
        define_method("#{field}_date") do
          if value = self.instance_variable_get("@#{field}")
            value.to_s(:va_date)
          end
        end
      end

      def initial_fields
        # TODO: factor logic out of case.rb
        {}
      end

      def required_fields
        # TODO: factor logic out of case.rb
        {}
      end
    end

    class Folder
      attr_reader :file_type

      def initialize(file_type)
        @file_type = file_type
      end
    end

    DATA = {
      "joe-snuffy" => Case.new(
        "abc",
        "22222222C",
        "3",
        "ADV",
        Date.parse('2015-09-01'),
        Date.parse('2015-09-01'),
        Date.parse('2015-09-01'),
        Date.parse('2015-09-01'),
        Date.parse('2015-09-01'),
        Date.parse('2015-09-01'),
        "22222222",
        "Post Remand",
        Folder.new("VBMS"),
      )
    }
  end
end
