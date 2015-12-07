module Caseflow
  CENTRAL_OFFICE_HEARING_ACTION = '1'
  TRAVEL_BOARD_HEARING_ACTION = '2'
  VIDEO_HEARING_HEARING_ACTION = '6'
  HEARING_ACTION_WITH_HEARING = [
    CENTRAL_OFFICE_HEARING_ACTION,
    TRAVEL_BOARD_HEARING_ACTION,
    VIDEO_HEARING_HEARING_ACTION
  ]

  def self.hearing_requested?(kase)
    kase.bfha && HEARING_ACTION_WITH_HEARING.include?(kase.bfha)
  end

  def self.format_issue_description(desc)
    desc.reject(&:nil?).reject(&:empty?).join(" - ")
  end

  def self.format_issues(kase, issue_type)
    issues = kase.issue_breakdown.select { |i| i['field_type'] == issue_type }
    formatted_issues = issues.map do |i|
      if issue_type == 'other'
        Caseflow.format_issue_description(
          [i['iss_desc'], i['lev1_desc'], i['lev2_desc'], i['lev3_desc']]
        )
      else
        Caseflow.format_issue_description([i['iss_desc'], i['full_desc']])
      end
    end
    formatted_issues.join('; ')
  end

  def self.initial_fields_for_case(kase)
    fields = {
      '1A_NAME_OF_APPELLANT' => kase.correspondent.appellant_name,
      '1B_RELATIONSHIP_TO_VETERAN' => kase.correspondent.appellant_relationship,
      '2_FILE_NO' => kase.bfcorlid,
      '3_LAST_NAME_FIRST_NAME_MIDDLE_NAME_OF_VETERAN' => kase.correspondent.full_name,
      '4_INSURANCE_FILE_NO_OR_LOAN_NO' => kase.bfpdnum,
      '5A_SERVICE_CONNECTION_FOR' => Caseflow.format_issues(kase, 'service connection'),
      '6A_INCREASED_RATING_FOR' => Caseflow.format_issues(kase, 'increased rating'),
      '7A_OTHER' => Caseflow.format_issues(kase, 'other'),
      '8A_APPELLANT_REPRESENTED_IN_THIS_APPEAL_BY' => kase.vso_full,
      '8B_POWER_OF_ATTORNEY' => '',
      '9A_IF_REPRESENTATIVE_IS_SERVICE_ORGANIZATION_IS_VA_FORM_646_YES' => '',
      '9A_IF_REPRESENTATIVE_IS_SERVICE_ORGANIZATION_IS_VA_FORM_646_NO' => '',
      '10A_WAS_HEARING_REQUESTED_YES' => kase.hearing_requested?,
      '10A_WAS_HEARING_REQUESTED_NO' => !kase.hearing_requested?,
      '12A_DATE_STATEMENT_OF_THE_CASE_FURNISHED' => kase.bfdsoc_date,
      '12B_SUPPLEMENTAL_STATEMENT_OF_THE_CASE_REQUIRED_AND_FURNISHED' => kase.ssoc_required?,
      '12B_SUPPLEMENTAL_STATEMENT_OF_THE_CASE_NOT_REQUIRED' => !kase.ssoc_required?,
      '15_NAME_AND_LOCATION_OF_CERTIFYING_OFFICE' => kase.regional_office_full,
      '16_ORGANIZATIONAL_ELEMENT_CERTIFIYING_APPEAL' => kase.bfregoff
    }

    if fields['5A_SERVICE_CONNECTION_FOR'].present?
      fields['5B_DATE_OF_NOTIFICATION_OF_ACTION_APPEALED'] = kase.bfdrodec_date
    end
    if fields['6A_INCREASED_RATING_FOR'].present?
      fields['6B_DATE_OF_NOTIFICATION_OF_ACTION_APPEALED'] = kase.bfdrodec_date
    end
    if fields['7A_OTHER'].present?
      fields['7B_DATE_OF_NOTIFICATION_OF_ACTION_APPEALED'] = kase.bfdrodec_date
    end

    fields
  end

  def self.required_fields_for_case(kase)
    fields = {}

    # Show if representative is attorney (T), agent (U), or one-time representative (W)
    if ['T', 'U', 'W'].include?(kase.bfso)
      fields[:show_8b] = true
      fields[:show_8c] = true
    # Show if there is no representative (L)
    elsif kase.bfso != 'L'
      fields[:show_8b] = true
    end

    # Show if no representative (L), attorney (T), agent (U), or one-time representative (W)
    if !['L', 'T', 'U', 'W'].include?(kase.bfso)
      fields[:show_9a] = true
    end

    if kase.hearing_requested?
      fields[:show_10b] = true
      fields[:show_10c] = true
    end

    fields
  end

  def self.ready_to_certify?(kase)
    kase.bfdnod_date == kase.efolder_nod_date &&
        kase.bfdsoc_date == kase.efolder_soc_date &&
        kase.bfssoc1_date == kase.efolder_ssoc1_date &&
        kase.bfssoc2_date == kase.efolder_ssoc2_date &&
        kase.bfssoc3_date == kase.efolder_ssoc3_date &&
        kase.bfssoc4_date == kase.efolder_ssoc4_date &&
        kase.bfssoc5_date == kase.efolder_ssoc5_date &&
        kase.bfd19_date == kase.efolder_form9_date
  end
end

class Case < ActiveRecord::Base
  include Caselike

  attr_reader :efolder_case

  self.table_name = 'vacols.brieff'
  self.sequence_name = 'vacols.bfkeyseq'
  self.primary_key = 'bfkey'

  belongs_to :correspondent, foreign_key: :bfcorkey, primary_key: :stafkey

  has_one :folder, foreign_key: :ticknum
  has_one :current_staff_location, class_name: StaffLocation, foreign_key: :stafkey, primary_key: :bfcurloc

  has_many :correspondences, foreign_key: :mlfolder

  FULL_VSO_NAMES = {
    'A' => ['The American Legion', 'American Legion'],
    'B' => ['AMVETS', 'AmVets'],
    'C' => ['American Red Cross', 'ARC'],
    'D' => ['Disabled American Veterans', 'DAV'],
    'E' => ['Jewish War Veterans', 'JWV'],
    'F' => ['Military Order of the Purple Heart', 'MOPH'],
    'G' => ['Paralyzed Veterans of America', 'PVA'],
    'H' => ['Veterans of Foreign Wars', 'VFW'],
    'I' => ['State Service Organization(s)', 'State Svc Org'],
    'J' => ['Maryland Veterans Commission', 'Md Veterans Comm'],
    'K' => ['Virginia Department of Veterans Affairs', 'Virginia Dept of Veteran'],
    'L' => ['No Representative', 'None'],
    'M' => ['Navy Mutual Aid Association', 'Navy Mut Aid'],
    'N' => ['Non-Commissioned Officers Association', 'NCOA'],
    'O' => ['Other Service Organization', 'Other'],
    'P' => ['Army & Air Force Mutual Aid Assn.', 'Army Mut Aid'],
    'Q' => ['Catholic War Veterans', 'Catholic War Vets'],
    'R' => ['Fleet Reserve Association', 'Fleet Reserve'],
    'S' => ['Marine Corp League', 'Marine Corps League'],
    'T' => ['Attorney', 'Attorney'],
    'U' => ['Agent', 'Agent'],
    'V' => ['Vietnam Veterans of America', 'VVA'],
    'W' => ['One Time Representative', 'One Time Rep'],
    'X' => ['American Ex-Prisoners of War', 'EXPOW'],
    'Y' => ['Blinded Veterans Association', 'Blinded Vet Assoc'],
    'Z' => ['National Veterans Legal Services Program', 'NVLSP'],
    '1' => ['National Veterans Organization of America', 'NVOA'],
    nil => nil,
  }
  FULL_VSO_NAMES.default = FULL_VSO_NAMES['O']

  [:bfdnod, :bfdrodec, :bfd19, :bfdsoc, :bfssoc1, :bfssoc2, :bfssoc3, :bfssoc4, :bfssoc5].each do |name|
    define_method("#{name}_date") do
      if value = self.send(name)
        value.to_s(:va_date)
      end
    end
  end

  def efolder_appellant_id
    id = self.bfcorlid.gsub(/[^0-9]/, '')
    if self.bfcorlid.ends_with?("C") && id.length == 7
      id = "0#{id}"
    end
    id
  end

  def efolder_case
    @efolder_case ||= EFolder::Case.new(efolder_appellant_id)
  end

  def clear_efolder_cache!
    @efolder_case = nil
  end

  def efolder_nod_date
    self.efolder_case.get_nod(self.bfdnod).try(:received_at).try(:to_s, :va_date) if self.bfdnod
  end

  def efolder_form9_date
    self.efolder_case.get_form9(self.bfd19).try(:received_at).try(:to_s, :va_date) if self.bfd19
  end

  def efolder_soc_date
    self.efolder_case.get_soc(self.bfdsoc).try(:received_at).try(:to_s, :va_date) if self.bfdsoc
  end

  (1..5).each do |i|
    define_method("efolder_ssoc#{i}_date") do
      if vacols_value = self.send("bfssoc#{i}")
        self.efolder_case.send(:get_ssoc, vacols_value).try(:received_at).try(:to_s, :va_date)
      end
    end
  end

  def required_fields
    Caseflow.required_fields_for_case(self)
  end

  def ready_to_certify?
    Caseflow.ready_to_certify?(self)
  end

  def appeal_type
    {
        '1' => 'Original',
        '2' => 'Supplemental',
        '3' => 'Post Remand',
        '4' => 'Reconsideration',
        '5' => 'Vacate',
        '6' => 'De Novo',
        '7' => 'Court Remand',
        '8' => 'Designation of Record',
        '9' => 'Clear and Unmistakable Error'
    }[bfac]
  end

  def vso
    FULL_VSO_NAMES[bfso]
  end

  def vso_full
    if vso.nil?
      "None"
    else
      vso.join(' - ')
    end
  end

  def regional_office
    hash = {
        'RO17' => ['St. Petersburg', 'FL'],
        'RO62' => ['Houston', 'TX'],
        'RO49' => ['Waco', 'TX'],
        'RO22' => ['Montgomery', 'AL'],
        'RO16' => ['Atlanta', 'GA'],
        'RO18' => ['Winston-Salem', 'NC'],
        'RO39' => ['Denver', 'CO'],
        'RO14' => ['Roanoke', 'VA'],
        'RO25' => ['Cleveland', 'OH'],
        'RO77' => ['San Diego', 'CA'],
        'RO43' => ['Oakland', 'CA'],
        'RO29' => ['Detroit', 'MI'],
        'RO20' => ['Nashville', 'TN'],
        'RO19' => ['Columbia', 'OH'],
        'RO48' => ['Portland', 'OR'],
        'RO46' => ['Seattle', 'WA'],
        'RO51' => ['Muskogee', 'OK'],
        'RO45' => ['Phoenix', 'AR'],
        'RO23' => ['Jackson', 'MS'],
        'RO10' => ['Philadelphia', 'PA'],
        'RO28' => ['Chicago', 'IL'],
        'RO44' => ['Los Angeles', 'CA'],
        'RO01' => ['Boston', 'MA'],
        'RO21' => ['New Orleans', 'LA'],
        'RO15' => ['Huntington', 'WV'],
        'RO30' => ['Milwaukee', 'WI'],
        'RO31' => ['St. Louis', 'MI'],
        'RO26' => ['Indianapolis', 'IN'],
        'RO50' => ['Little Rock', 'AR'],
        'RO06' => ['New York', 'NY'],
        'RO07' => ['Buffalo', 'NY'],
        'RO09' => ['Newark', 'NJ'],
        'RO35' => ['St. Paul', 'MN'],
        'RO34' => ['Lincoln', 'NE'],
        'RO33' => ['Des Moines', 'IA'],
        'RO27' => ['Louisville', 'KY'],
        'RO40' => ['Albuquerque', 'NM'],
        'RO55' => ['San Juan', 'PR'],
        'RO04' => ['Providence', 'RI'],
        'RO13' => ['Baltimore', 'MD'],
        'RO47' => ['Boise', 'ID'],
        'RO41' => ['Salt Lake City', 'UT'],
        'RO52' => ['Wichita', 'KS'],
        'RO59' => ['Honolulu', 'HI'],
        'RO54' => ['Reno', 'NV'],
        'RO11' => ['Pittsburgh', 'PA'],
        'RO08' => ['Hartford', 'CT'],
        'RO63' => ['Anchorage', 'AK'],
        'RO58' => ['Manila', 'PI'],
        'RO60' => ['Wilmington', 'DE'],
        'RO36' => ['Ft. Harrison', 'MT'],
        'RO38' => ['Sioux Falls', 'SD'],
        'RO02' => ['Togus', 'ME'],
        'RO73' => ['Manchester', 'NH'],
        'RO37' => ['Fargo', 'ND'],
        'RO05' => ['White River Junction', 'VT'],
        'RO42' => ['Cheyenne', 'WY'],
        'DSUSER' => ['Digital Service'],
    }
    hash[bfregoff]
  end

  def regional_office_full
    if regional_office.nil?
      bfregoff
    else
      regional_office.join(', ')
    end
  end

  def initial_fields
    @initial_fields ||= Caseflow.initial_fields_for_case(self)
  end

  def hearing_requested?
    Caseflow.hearing_requested?(self)
  end

  def hearing_transcripts_present?
    # TODO: Make this actually work
  end

  def contested_claims?
    # TODO: Make this actually work
  end

  def ssoc_required?
    bfssoc1.present?
  end

  def issue_breakdown
    return @issue_breakdown if @issue_breakdown

    query = self.class.send(:sanitize_sql, [<<-SQL, self.bfkey])
    SELECT ISSUES.ISSSEQ,
      ISSUES.ISSPROG,
      ISSUES.ISSCODE,
      ISSUES.ISSLEV1,
      ISSUES.ISSLEV2,
      ISSUES.ISSLEV3,
      ISSREF.PROG_DESC,
      ISSREF.ISS_DESC,
      ISSREF.LEV1_DESC,
      ISSREF.LEV2_DESC,
      ISSREF.LEV3_DESC
    FROM ISSUES, ISSREF
    WHERE ISSUES.ISSPROG = ISSREF.PROG_CODE AND
          ( ISSUES.ISSCODE = ISSREF.ISS_CODE ) AND
          ( ISSLEV1 = LEV1_CODE OR LEV1_CODE = '##' OR LEV1_CODE IS NULL ) AND
          ( ISSLEV2 = LEV2_CODE OR LEV2_CODE = '##' OR LEV2_CODE IS NULL ) AND
          ( ISSLEV3 = LEV3_CODE OR LEV3_CODE = '##' OR LEV3_CODE IS NULL ) AND
          ( ISSUES.ISSKEY = ? AND ISSUES.ISSDC IS NULL )
    SQL

    issues = self.class.connection.select_all(query).to_hash

    issues.each do |issue|
      if issue['issprog'] == '02' && issue['isscode'] == '15'
        issue['field_type'] = 'service connection'
      elsif issue['issprog'] == '02' && issue['isscode'] == '12'
        issue['field_type'] = 'increased rating'
      else
        issue['field_type'] = 'other'
      end

      if issue['isslev2'] && issue['isslev2'].length == 4
        issue['full_desc'] = diagnostic_lookup(issue['isslev2'])
      end
      if issue['isslev3'] && issue['isslev3'].length == 4
        issue['full_desc'] = diagnostic_lookup(issue['isslev3'])
      end
    end

    @issue_breakdown = issues
  end

  private

  def diagnostic_lookup(code)
    vf = VfType.lookup(code)
    [vf.ftkey, vf.ftdesc].join(' ')
  end
end
