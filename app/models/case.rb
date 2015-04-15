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
    return @initial_fields if @initial_fields

    fields = {
      '1A_NAME_OF_APPELLANT'                                              => self.correspondent.appellant_name,
      '1B_RELATIONSHIP_TO_VETERAN'                                        => self.correspondent.appellant_relationship,
      '2_FILE_NO'                                                         => self.bfcorlid,
      '3_LAST_NAME_FIRST_NAME_MIDDLE_NAME_OF_VETERAN'                     => self.correspondent.full_name,
      '4_INSURANCE_FILE_NO_OR_LOAN_NO'                                    => self.bfpdnum,
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

    fields['5A_SERVICE_CONNECTION_FOR'] = issue_breakdown.select {|i| i['field_type'] == 'service connection' }.map { |i| i['full_desc'] }.join(';')
    fields['6A_INCREASED_RATING_FOR'] = issue_breakdown.select {|i| i['field_type'] == 'increased rating' }.map { |i| i['iss_desc'] }.join(';')
    fields['7A_OTHER'] = issue_breakdown.select {|i| i['field_type'] == 'other' }.map { |i| i['iss_desc'] }.join(';')

    if fields['5A_SERVICE_CONNECTION_FOR'].present?
      fields['5B_DATE_OF_NOTIFICATION_OF_ACTION_APPEALED'] = Time.now.to_s(:va_date)
    end
    if fields['6A_INCREASED_RATING_FOR'].present?
      fields['6B_DATE_OF_NOTIFICATION_OF_ACTION_APPEALED'] = Time.now.to_s(:va_date)
    end
    if fields['7A_OTHER'].present?
      fields['7B_DATE_OF_NOTIFICATION_OF_ACTION_APPEALED'] = Time.now.to_s(:va_date)
    end

    @initial_fields = fields
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

  def issue_breakdown
    return @issue_breakdown if @issue_breakdown

    issues = self.class.connection.select_all(<<-SQL).to_hash
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
          ( ISSUES.ISSKEY = '#{self.bfkey}' AND ISSUES.ISSDC IS NULL )
    SQL

    issues.each.with_index do |issue, idx|
      if issue['issprog'] == '02' && issue['isscode'] == '15'
        issues[idx]['field_type'] = 'service connection'
      elsif issue['issprog'] == '02' && issue['isscode'] == '12'
        issues[idx]['field_type'] = 'increased rating'
      else
        issues[idx]['field_type'] = 'other'
      end

      if issue['isslev2'] && issue['isslev2'].length == 4
        issues[idx]['full_desc'] = diagnostic_lookup(issue['isslev2'])
      end
      if issue['isslev3'] && issue['isslev3'].length == 4
        issues[idx]['full_desc'] = diagnostic_lookup(issue['isslev3'])
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