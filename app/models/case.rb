class Case < ActiveRecord::Base
  include Caselike

  self.table_name = 'vacols.brieff'
  self.sequence_name = 'vacols.bfkeyseq'
  self.primary_key = 'bfkey'

  belongs_to :correspondent, foreign_key: :bfcorkey, primary_key: :stafkey

  has_one :folder, foreign_key: :ticknum
  has_one :current_staff_location, class: StaffLocation, foreign_key: :stafkey, primary_key: :bfcurloc

  has_many :correspondences, foreign_key: :mlfolder

  [:bfdnod, :bfd19, :bfdsoc, :bfssoc1, :bfssoc2, :bfssoc3, :bfssoc4, :bfssoc5].each do |name|
    define_method("#{name}_date") do
      if value = self.send(name)
        value.to_s(:va_date)
      end
    end
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
    hash = {
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
        '1' => ['National Veterans Organization of America', 'NVOA']
    }
    hash.default(hash['O'])
    hash[bfso]
  end

  def vso_full
    vso.join(' - ')
  end

  def initial_fields
    {
      '1A_NAME_OF_APPELLANT'                                              => self.correspondent.appellant_name,
      '1B_RELATIONSHIP_TO_VETERAN'                                        => self.correspondent.appellant_relationship,
      '2_FILE_NO'                                                         => self.bfcorlid,
      '3_LAST_NAME_FIRST_NAME_MIDDLE_NAME_OF_VETERAN'                     => self.correspondent.full_name,
      '4_INSURANCE_FILE_NO_OR_LOAN_NO'                                    => self.bfpdnum,
      '5A_SERVICE_CONNECTION_FOR'                                         => '',
      '5B_DATE_OF_NOTIFICATION_OF_ACTION_APPEALED'                        => '',
      '6A_INCREASED_RATING_FOR'                                           => '',
      '6B_DATE_OF_NOTIFICATION_OF_ACTION_APPEALED'                        => '',
      '7A_OTHER'                                                          => '',
      '7B_DATE_OF_NOTIFICATION_OF_ACTION_APPEALED'                        => '',
      '8A_APPELLANT_REPRESENTED_IN_THIS_APPEAL_BY'                        => self.vso_full,
      '8B_POWER_OF_ATTORNEY'                                              => '',
      '9A_IF_REPRESENTATIVE_IS_SERVICE_ORGANIZATION_IS_VA_FORM_646_YES'   => '',
      '9A_IF_REPRESENTATIVE_IS_SERVICE_ORGANIZATION_IS_VA_FORM_646_NO'    => '',
      '10A_WAS_HEARING_REQUESTED_YES'                                     => self.hearing_requested?,
      '10A_WAS_HEARING_REQUESTED_NO'                                      => !self.hearing_requested?,
      '10B_IF_HELD_IS_TRANSCRIPT_IN_FILE_YES'                             => self.hearing_transcripts_present?,
      '10B_IF_HELD_IS_TRANSCRIPT_IN_FILE_NO'                              => !self.hearing_transcripts_present?,
      '11A_ARE_CONTESTED_CLAIMS_PROCEDURES_APPLICABLE_IN_THIS_CASE_YES'   => self.contested_claims?,
      '11A_ARE_CONTESTED_CLAIMS_PROCEDURES_APPLICABLE_IN_THIS_CASE_NO'    => !self.contested_claims?,
      '12A_DATE_STATEMENT_OF_THE_CASE_FURNISHED'                          => self.bfdsoc_date,
      '12B_SUPPLEMENTAL_STATEMENT_OF_THE_CASE_REQUIRED_AND_FURNISHED'     => self.ssoc_required?,
      '12B_SUPPLEMENTAL_STATEMENT_OF_THE_CASE_NOT_REQUIRED'               => !self.ssoc_required?,
      '13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_CF_OR_XCF' => true
    }
  end

  def hearing_requested?
    if bfha && ['1', '2', '6'].include?(bfha)
      true
    else
      false
    end
  end

  def hearing_transcripts_present?
    # TODO: Make this actually work
    true
  end

  def contested_claims?
    # TODO: Make this actually work
    true
  end

  def ssoc_required?
    bfssoc1.present?
  end
end