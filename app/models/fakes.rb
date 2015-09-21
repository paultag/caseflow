module Caseflow
  module Fakes
    class Case
      attr_reader(:bfkey, :bfcorlid, :bfac, :bfmpro, :bfpdnum, :bfregoff,
        :efolder_appellant_id, :appeal_type, :vso_full, :regional_office_full,
        :folder, :correspondent, :save_successful, :issue_breakdown)
      attr_accessor :bf41stat

      def self.find(bfkey)
        kase = Caseflow::Fakes::DATA[bfkey]
        if kase.nil?
          raise ActiveRecord::RecordNotFound
        end
        kase
      end

      # TODO: when we have Ruby 2.1, use required keyword arguments.
      def initialize(bfkey: nil, bfcorlid: nil, bfac: nil, bfmpro: nil,
                     bfpdnum: nil, bfregoff: nil, bfdnod: nil, bfd19: nil,
                     bfdsoc: nil, efolder_nod: nil, efolder_form9: nil,
                     efolder_soc: nil, efolder_appellant_id: nil,
                     appeal_type: nil, vso_full: nil, regional_office_full: nil,
                     folder: nil, correspondent: nil, save_successful: true,
                     issue_breakdown: [])
        @bfkey = bfkey
        @bfcorlid = bfcorlid
        @bfac = bfac
        @bfmpro = bfmpro
        @bfpdnum = bfpdnum

        @bfdnod = bfdnod
        @bfd19 = bfd19
        @bfdsoc = bfdsoc
        @bfregoff = bfregoff

        @efolder_nod = efolder_nod
        @efolder_form9 = efolder_form9
        @efolder_soc = efolder_soc

        @efolder_appellant_id = efolder_appellant_id
        @appeal_type = appeal_type
        @vso_full = vso_full

        @folder = folder
        @correspondent = correspondent
        @save_successful = save_successful
        @issue_breakdown = issue_breakdown
        @regional_office_full = regional_office_full
        @bfregoff = bfregoff
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

      def efolder_case
        Caseflow::Fakes::EFolderCase.new
      end

      def bfdcertool=(value)
      end

      def bfdmcon=(value)
      end

      def bfms=(value)
      end

      def hearing_requested?
        true
      end

      def ssoc_required?
        false
      end

      def bfso
        nil
      end

      def save
        @save_successful
      end

      def initial_fields
        # TODO: needed to trigger autoload of case.rb
        ::Case
        Caseflow.initial_fields_for_case(self)
      end

      def required_fields
        # TODO: needed to trigger autoload of case.rb
        ::Case
        Caseflow.required_fields_for_case(self)
      end

      def ready_to_certify?
        ::Case
        Caseflow.ready_to_certify?(self)
      end
    end

    class Folder
      attr_reader :file_type

      def initialize(file_type)
        @file_type = file_type
      end
    end

    class Correspondent
      attr_reader(:appellant_name, :appellant_relationship, :full_name, :snamef,
        :snamemi, :snamel)

      def initialize(appellant_name, appellant_relationship, full_name, snamef, snamemi, snamel)
        @appellant_name = appellant_name
        @appellant_relationship = appellant_relationship
        @full_name = full_name

        @snamef = snamef
        @snamemi = snamemi
        @snamel = snamel
      end
    end

    class EFolderCase
      def upload_form8(first_name, middle_initial, last_name, file_name)
      end
    end

    DATA = {
      'joe-snuffy' => Case.new(
        bfkey: 'joe-snuffy',
        bfcorlid: '22222222C',
        bfac: '3',
        bfmpro: 'ADV',
        bfpdnum: '123ABC',
        bfregoff: 'DSUSER',
        bfdnod: Date.parse('2015-09-01'),
        bfd19: Date.parse('2015-09-01'),
        bfdsoc: Date.parse('2015-09-01'),
        efolder_nod: Date.parse('2015-09-01'),
        efolder_form9: Date.parse('2015-09-01'),
        efolder_soc: Date.parse('2015-09-01'),
        efolder_appellant_id: '22222222',
        appeal_type: 'Post Remand',
        vso_full: 'Disabled American Veterans',
        regional_office_full: 'Philadelphia, PA',
        folder: Folder.new('VBMS'),
        correspondent: Correspondent.new(
          'Joe Snuffy', 'Self', 'Joe Snuffy', 'Joe', '', 'Snuffy',
        ),
      ),
      'janice-snuffy' => Case.new(
        bfkey: 'janice-snuffy',
        bfcorlid: '444444444C',
        bfac: '3',
        bfmpro: 'ADV',
        bfpdnum: '123ABC',
        bfregoff: 'DSUSER',
        bfdnod: Date.parse('2015-09-01'),
        bfd19: Date.parse('2015-09-01'),
        bfdsoc: Date.parse('2015-09-01'),
        efolder_nod: Date.parse('2015-09-02'),
        efolder_form9: Date.parse('2015-09-01'),
        efolder_soc: Date.parse('2015-09-03'),
        efolder_appellant_id: '444444444',
        appeal_type: 'Post Remand',
        vso_full: 'Jewish American Veterans',
        regional_office_full: 'Philadelphia, PA',
        folder: Folder.new('VBMS'),
        correspondent: Correspondent.new(
          'Janice Snuffy', 'Self', 'Janice Snuffy', 'Janice', '', 'Snuffy',
        ),
      ),
      'not-authorized' => Case.new(
        bfkey: 'not-authorized',
        bfcorlid: '44444445C',
        bfac: '3',
        bfmpro: 'ADV',
        bfpdnum: '123ABC',
        bfregoff: 'dfakl;dfakldfaj;',
        bfdnod: Date.parse('2015-09-01'),
        bfd19: Date.parse('2015-09-01'),
        bfdsoc: Date.parse('2015-09-01'),
        efolder_nod: Date.parse('2015-09-02'),
        efolder_form9: Date.parse('2015-09-01'),
        efolder_soc: Date.parse('2015-09-03'),
        efolder_appellant_id: '444444445',
        appeal_type: 'Post Remand',
        vso_full: 'Unauthorized American Veterans',
        regional_office_full: 'Philadelphia, PA',
        folder: Folder.new('VBMS'),
        correspondent: Correspondent.new(
          'Not Authorized', 'Self', 'Not Authorized', 'Not', '', 'Authorized',
        ),
      ),
      'full-form8' => Case.new(
        bfkey: 'full-form8',
        bfcorlid: '444444446C',
        bfac: '3',
        bfmpro: 'ADV',
        bfpdnum: '123ABC',
        bfregoff: 'RO10',
        bfdnod: Date.parse('2015-09-01'),
        bfd19: Date.parse('2015-09-01'),
        bfdsoc: Date.parse('2015-09-01'),
        efolder_nod: Date.parse('2015-09-01'),
        efolder_form9: Date.parse('2015-09-01'),
        efolder_soc: Date.parse('2015-09-01'),
        efolder_appellant_id: '444444444',
        appeal_type: 'Post Remand',
        vso_full: 'Thorough American Veterans',
        regional_office_full: 'Philadelphia, PA',
        folder: Folder.new('VBMS'),
        correspondent: Correspondent.new(
          'Full Form8', 'Self', 'Full Form8', 'Full', 'Numberinmylastname', 'Form8',
        ),
        issue_breakdown: [
          { 'field_type' => 'service connection', 'full_desc' => 'broken ankle'},
          { 'field_type' => 'service connection', 'full_desc' => 'broken toe'},
          { 'field_type' => 'service connection', 'full_desc' => 'broken toe nail'},
          { 'field_type' => 'increased rating', 'iss_desc' => 'popped ankle'},
          { 'field_type' => 'increased rating', 'iss_desc' => 'twisted toe'},
          { 'field_type' => 'increased rating', 'iss_desc' => 'blackened toe nail'},
          { 'field_type' => 'other', 'iss_desc' => 'enlarged ankle'},
          { 'field_type' => 'other', 'iss_desc' => 'gross toe nail'}
        ]
      )
    }
  end
end
