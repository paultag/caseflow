class FormVa8 < Caseflow::FormBuilder
  self.form_name = 'VA8'

  self.check_symbol = '1'
  self.field_legend = {
    '1A_NAME_OF_APPELLANT'                                                  => {id: "form1[0].#subform[0].#area[0].TextField1[0]",  type: :text},
    '1B_RELATIONSHIP_TO_VETERAN'                                            => {id: "form1[0].#subform[0].#area[0].TextField1[1]",  type: :text},
    '2_FILE_NO'                                                             => {id: "form1[0].#subform[0].#area[0].TextField1[2]",  type: :text},
    '3_LAST_NAME_FIRST_NAME_MIDDLE_NAME_OF_VETERAN'                         => {id: "form1[0].#subform[0].#area[0].TextField1[3]",  type: :text},
    '4_INSURANCE_FILE_NO_OR_LOAN_NO'                                        => {id: "form1[0].#subform[0].#area[0].TextField1[4]",  type: :text},
    '5A_SERVICE_CONNECTION_FOR'                                             => {id: "form1[0].#subform[0].#area[0].TextField1[5]",  type: :text},
    '5B_DATE_OF_NOTIFICATION_OF_ACTION_APPEALED'                            => {id: "form1[0].#subform[0].#area[0].TextField1[6]",  type: :text},
    '6A_INCREASED_RATING_FOR'                                               => {id: "form1[0].#subform[0].#area[0].TextField1[7]",  type: :text},
    '6B_DATE_OF_NOTIFICATION_OF_ACTION_APPEALED'                            => {id: "form1[0].#subform[0].#area[0].TextField1[8]",  type: :text},
    '7A_OTHER'                                                              => {id: "form1[0].#subform[0].#area[0].TextField1[9]",  type: :text},
    '7B_DATE_OF_NOTIFICATION_OF_ACTION_APPEALED'                            => {id: "form1[0].#subform[0].#area[0].TextField1[10]", type: :text},
    '8A_APPELLANT_REPRESENTED_IN_THIS_APPEAL_BY'                            => {id: "form1[0].#subform[0].#area[0].TextField1[11]", type: :text},
    '8B_POWER_OF_ATTORNEY'                                                  => {id: "form1[0].#subform[0].#area[0].CheckBox21[0]",  type: :check},
    '8B_CERTIFICATION_THAT_VALID_POWER_OF_ATTORNEY_IS_IN_ANOTHER_VA_FILE'   => {id: "form1[0].#subform[0].#area[0].CheckBox21[1]",  type: :check},
    '8B_REMARKS'                                                            => {id: "form1[0].#subform[0].#area[0].TextField1[12]", type: :text},
    '8C_IF_AGENT_DESIGNATED_IS_HE_SHE_ON_ACCREDITED_LIST_YES'               => {id: "form1[0].#subform[0].#area[0].CheckBox23[0]",  type: :check},
    '8C_IF_AGENT_DESIGNATED_IS_HE_SHE_ON_ACCREDITED_LIST_NO'                => {id: "form1[0].#subform[0].#area[0].CheckBox23[1]",  type: :check},
    '9A_IF_REPRESENTATIVE_IS_SERVICE_ORGANIZATION_IS_VA_FORM_646_YES'       => {id: "form1[0].#subform[0].#area[0].CheckBox23[2]",  type: :check},
    '9A_IF_REPRESENTATIVE_IS_SERVICE_ORGANIZATION_IS_VA_FORM_646_NO'        => {id: "form1[0].#subform[0].#area[0].CheckBox23[3]",  type: :check},
    '9B_IF_VA_FORM_646_IS_NOT_OF_RECORD_EXPLAIN'                            => {id: "form1[0].#subform[0].#area[0].TextField1[13]", type: :text},
    '10A_WAS_HEARING_REQUESTED_YES'                                         => {id: "form1[0].#subform[0].#area[0].CheckBox23[4]",  type: :check},
    '10A_WAS_HEARING_REQUESTED_NO'                                          => {id: "form1[0].#subform[0].#area[0].CheckBox23[5]",  type: :check},
    '10B_IF_HELD_IS_TRANSCRIPT_IN_FILE_YES'                                 => {id: "form1[0].#subform[0].#area[0].CheckBox23[6]",  type: :check},
    '10B_IF_HELD_IS_TRANSCRIPT_IN_FILE_NO'                                  => {id: "form1[0].#subform[0].#area[0].CheckBox23[7]",  type: :check},
    '10C_IF_REQUESTED_BUT_NOT_HELD_EXPLAIN'                                 => {id: "form1[0].#subform[0].#area[0].TextField1[14]", type: :text},
    '11A_ARE_CONTESTED_CLAIMS_PROCEDURES_APPLICABLE_IN_THIS_CASE_YES'       => {id: "form1[0].#subform[0].#area[0].CheckBox23[8]",  type: :check},
    '11A_ARE_CONTESTED_CLAIMS_PROCEDURES_APPLICABLE_IN_THIS_CASE_NO'        => {id: "form1[0].#subform[0].#area[0].CheckBox23[9]",  type: :check},
    '11B_HAVE_THE_REQUIREMENTS_OF_38_USC_BEEN_FOLLOWED_YES'                 => {id: "form1[0].#subform[0].#area[0].CheckBox23[10]", type: :check},
    '11B_HAVE_THE_REQUIREMENTS_OF_38_USC_BEEN_FOLLOWED_NO'                  => {id: "form1[0].#subform[0].#area[0].CheckBox23[11]", type: :check},
    '12A_DATE_STATEMENT_OF_THE_CASE_FURNISHED'                              => {id: "form1[0].#subform[0].#area[0].TextField1[15]", type: :text},
    '12B_SUPPLEMENTAL_STATEMENT_OF_THE_CASE_REQUIRED_AND_FURNISHED'         => {id: "form1[0].#subform[0].#area[0].CheckBox23[12]", type: :check},
    '12B_SUPPLEMENTAL_STATEMENT_OF_THE_CASE_NOT_REQUIRED'                   => {id: "form1[0].#subform[0].#area[0].CheckBox23[13]", type: :check},
    '13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_CF_OR_XCF'     => {id: "form1[0].#subform[0].#area[0].CheckBox23[14]", type: :check},
    '13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_REF'           => {id: "form1[0].#subform[0].#area[0].CheckBox23[15]", type: :check},
    '13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_LOAD_GUAR'     => {id: "form1[0].#subform[0].#area[0].CheckBox23[16]", type: :check},
    '13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_OUTPATIENT_F'  => {id: "form1[0].#subform[0].#area[0].CheckBox23[17]", type: :check},
    '13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_XRAYS'         => {id: "form1[0].#subform[0].#area[0].CheckBox23[18]", type: :check},
    '13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_INACTIVE_CF'   => {id: "form1[0].#subform[0].#area[0].CheckBox23[19]", type: :check},
    '13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_TRAINING_SUBF' => {id: "form1[0].#subform[0].#area[0].CheckBox23[20]", type: :check},
    '13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_INSURANCE_F'   => {id: "form1[0].#subform[0].#area[0].CheckBox23[21]", type: :check},
    '13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_HOSPITAL_COR'  => {id: "form1[0].#subform[0].#area[0].CheckBox23[22]", type: :check},
    '13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_SLIDES'        => {id: "form1[0].#subform[0].#area[0].CheckBox23[23]", type: :check},
    '13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_DEP_ED_F'      => {id: "form1[0].#subform[0].#area[0].CheckBox23[24]", type: :check},
    '13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_DENTAL_F'      => {id: "form1[0].#subform[0].#area[0].CheckBox23[25]", type: :check},
    '13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_CLINICAL_REC'  => {id: "form1[0].#subform[0].#area[0].CheckBox23[26]", type: :check},
    '13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_TISSUE_BLOCKS' => {id: "form1[0].#subform[0].#area[0].CheckBox23[27]", type: :check},
    '13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_OTHER'         => {id: "form1[0].#subform[0].#area[0].CheckBox23[28]", type: :check},
    '13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_OTHER_REMARKS' => {id: "form1[0].#subform[0].#area[0].TextField1[16]", type: :text},
    '14_REMARKS_INITIAL'                                                    => {id: "form1[0].#subform[0].#area[0].TextField1[17]", type: :text},
    '15_NAME_AND_LOCATION_OF_CERTIFYING_OFFICE'                             => {id: "form1[0].#subform[0].#area[0].TextField1[18]", type: :text},
    '16_ORGANIZATIONAL_ELEMENT_CERTIFIYING_APPEAL'                          => {id: "form1[0].#subform[0].#area[0].TextField1[19]", type: :text},
    '17A_SIGNATURE_OF_CERTIFYING_OFFICIAL'                                  => {id: "form1[0].#subform[0].#area[0].TextField1[20]", type: :text},
    '17B_TITLE'                                                             => {id: "form1[0].#subform[0].#area[0].TextField1[21]", type: :text},
    '17C_DATE'                                                              => {id: "form1[0].#subform[0].#area[0].TextField1[22]", type: :text},
    '18A_SIGNATURE_OF_MEDICAL_MEMBER'                                       => {id: "form1[0].#subform[0].#area[0].TextField1[23]", type: :text},
    '18B_TITLE'                                                             => {id: "form1[0].#subform[0].#area[0].TextField1[24]", type: :text},
    '18C_DATE'                                                              => {id: "form1[0].#subform[0].#area[0].TextField1[25]", type: :text},
    '14_REMARKS_CONTINUED'                                                  => {id: "form1[0].#subform[1].TextField1[26]",          type: :text}
  }
end