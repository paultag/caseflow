module Caseflow
  module Fakes
    class Case
      attr_reader(:bfkey, :bfcorlid, :bfac, :bfmpro, :bfpdnum, :bfregoff,
        :efolder_appellant_id, :appeal_type, :vso_full, :regional_office_full,
        :folder, :correspondent)

      def self.find(bfkey)
        return Caseflow::Fakes::DATA[bfkey]
      end

      # TODO: when we have Ruby 2.1, use required keyword arguments.
      def initialize(bfkey: nil, bfcorlid: nil, bfac: nil, bfmpro: nil,
                     bfpdnum: nil, bfregoff: nil, bfdnod: nil, bfd19: nil,
                     bfdsoc: nil, efolder_nod: nil, efolder_form9: nil,
                     efolder_soc: nil, efolder_appellant_id: nil,
                     appeal_type: nil, vso_full: nil, regional_office_full: nil,
                     folder: nil, correspondent: nil)
        @bfkey = bfkey
        @bfcorlid = bfcorlid
        @bfac = bfac
        @bfmpro = bfmpro
        @bfpdnum = bfpdnum

        @bfdnod = bfdnod
        @bfd19 = bfd19
        @bfdsoc = bfdsoc

        @efolder_nod = efolder_nod
        @efolder_form9 = efolder_form9
        @efolder_soc = efolder_soc

        @efolder_appellant_id = efolder_appellant_id
        @appeal_type = appeal_type
        @vso_full = vso_full

        @folder = folder
        @correspondent = correspondent
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

      # TODO: allow customizing these fields
      def issue_breakdown
        []
      end

      def hearing_requested?
        true
      end

      def ssoc_required?
        false
      end

      def initial_fields
        # TODO: needed to trigger autoload of case.rb
        ::Case
        Caseflow.initial_fields_for_case(self)
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

    class Correspondent
      attr_reader :appellant_name, :appellant_relationship, :full_name

      def initialize(appellant_name, appellant_relationship, full_name)
        @appellant_name = appellant_name
        @appellant_relationship = appellant_relationship
        @full_name = full_name
      end
    end

    DATA = {
      "joe-snuffy" => Case.new(
        bfkey: "abc",
        bfcorlid: "22222222C",
        bfac: "3",
        bfmpro: "ADV",
        bfpdnum: "123ABC",
        bfregoff: "RO10",
        bfdnod: Date.parse('2015-09-01'),
        bfd19: Date.parse('2015-09-01'),
        bfdsoc: Date.parse('2015-09-01'),
        efolder_nod: Date.parse('2015-09-01'),
        efolder_form9: Date.parse('2015-09-01'),
        efolder_soc: Date.parse('2015-09-01'),
        efolder_appellant_id: "22222222",
        appeal_type: "Post Remand",
        vso_full: "Disabled American Veterans",
        regional_office_full: "Philadelphia, PA",
        folder: Folder.new("VBMS"),
        correspondent: Correspondent.new(
          "Joe Snuffy", "Self", "Joe Snuffy",
        ),
      )
    }
  end
end
