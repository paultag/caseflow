module Caseflow
  module Fakes
    class Case
      attr_reader(:bfkey, :bfcorlid, :bfac, :bfmpro, :bfpdnum, :bfregoff,
        :bfdrodec, :bfdnod, :bfd19, :bfdsoc, :efolder_appellant_id, :appeal_type,
        :vso_full, :regional_office_full, :folder, :correspondent,
        :save_successful, :issue_breakdown, :bfso, :bfha)
      attr_accessor :bf41stat

      def self.find(bfkey)
        kase = Caseflow::Fakes::data[bfkey]
        if kase.nil?
          raise ActiveRecord::RecordNotFound
        end
        kase
      end

      # TODO: when we have Ruby 2.1, use required keyword arguments.
      def initialize(bfkey: nil, bfcorlid: nil, bfac: nil, bfmpro: nil,
                     bfpdnum: nil, bfregoff: nil, bfdrodec: nil, bfdnod: nil,
                     bfd19: nil, bfdsoc: nil, bf41stat: nil, efolder_nod: nil,
                     efolder_form9: nil, efolder_soc: nil,
                     efolder_appellant_id: nil, appeal_type: nil, vso_full: nil,
                     regional_office_full: nil, folder: nil, correspondent: nil,
                     save_successful: true, issue_breakdown: [], bfso: nil, bfha: nil)
        @bfkey = bfkey
        @bfcorlid = bfcorlid
        @bfac = bfac
        @bfmpro = bfmpro
        @bfpdnum = bfpdnum
        @bfregoff = bfregoff
        @bfdrodec = bfdrodec

        @bfdnod = bfdnod
        @bfd19 = bfd19
        @bfdsoc = bfdsoc
        @bf41stat = bf41stat

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
        @bfso = bfso
        @bfha = bfha
      end

      DATE_FIELDS = [
        :bfdrodec, :bfdnod, :bfd19, :bfdsoc, :bfssoc1, :bfssoc2, :bfssoc3,
        :bfssoc4, :bfssoc5, :efolder_nod, :efolder_form9, :efolder_soc,
        :efolder_ssoc1, :efolder_ssoc2, :efolder_ssoc3, :efolder_ssoc4,
        :efolder_ssoc5
      ]
      DATE_FIELDS.each do |field|
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
        # TODO: needed to trigger autoload of case.rb
        ::Case
        Caseflow.hearing_requested?(self)
      end

      def ssoc_required?
        false
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

    def self.case_from_json(data)
      # Create a new case from the JSON Fakes format, in particular, we need
      # to hydrate the object with real Date objects, a real Folder object, and
      # a real Correspondent object.
      Caseflow::Fakes::Case::DATE_FIELDS.each do |field|
        if data.has_key?(field)
          data[field] = Date.parse(data[field])
        end
      end
      data[:folder] = Folder.new(data[:folder])
      data[:correspondent] = Correspondent.new(*data[:correspondent])
      Case.new(**data)
    end

    def self.load_data
      # Read the JSON off disk, and turn it into the Fakes data format, so that
      # we can find keys by indexing into it. Key is a string (bfkey). Each
      # entry is run through `case_from_json` to turn it into a live Case object.
      fakes = "app/fixtures/cases.json"
      if ENV.has_key?('CASEFLOW_FAKES')
        fakes = ENV['CASEFLOW_FAKES']
      end

      File.open(fakes, "r") do |f|
        data = JSON.load(f).deep_symbolize_keys
        data.map {|k, v| [k.to_s, Caseflow::Fakes::case_from_json(v)]}.to_h
      end
    end

    def self.data
      @DATA ||= load_data
    end

  end
end
