module Api
  class CertificationsController < ApiController
    # def start
    #   data = {}
    #   kase = Case.find(params[:id])
    #
    #   data[:info] = {
    #       bfkey: kase.bfkey,
    #       bfcorlid: kase.bfcorlid,
    #       bfac: kase.bfac,
    #       bfmpro: kase.bfmpro,
    #       bfdnod: kase.bfdnod_date,
    #       bfd19: kase.bfd19_date,
    #       bfdsoc: kase.bfdsoc_date,
    #       bfssoc1: kase.bfssoc1_date,
    #       bfssoc2: kase.bfssoc2_date,
    #       bfssoc3: kase.bfssoc3_date,
    #       bfssoc4: kase.bfssoc4_date,
    #       bfssoc5: kase.bfssoc5_date,
    #       appeal_type: kase.appeal_type,
    #       file_type: kase.folder.file_type
    #   }
    #
    #   data[:fields] = kase.initial_fields
    #
    #   data[:required_fields] = kase.required_fields
    #
    #   render json: data
    # end

    def generate
      certification_date = Time.now.to_s(:va_date)

      fields = params[:fields]
      fields['17C_DATE'] = certification_date

      form_8 = FormVa8.new(params[:fields])
      form_8.process!

      render json: {status: 'ok', file_name: form_8.file_name, bf41stat: certification_date}, status: :created
    end

  def start
    render json: {"info"=>
                {"bfkey"=>"2741506",
                 "bfcorlid"=>"22222222C",
                 "bfac"=>"3",
                 "bfmpro"=>"ADV",
                 "bfdnod"=>"02/04/2011",
                 "bfd19"=>"05/01/2013",
                 "bfdsoc"=>"04/03/2012",
                 "bfssoc1"=>nil,
                 "bfssoc2"=>nil,
                 "bfssoc3"=>nil,
                 "bfssoc4"=>nil,
                 "bfssoc5"=>nil,
                 "appeal_type"=>"Post Remand",
                 "file_type"=>"Paper"},
            "fields"=>
                {"1A_NAME_OF_APPELLANT"=>"SNUFFY, JANE, A",
                 "1B_RELATIONSHIP_TO_VETERAN"=>"WIDOW",
                 "2_FILE_NO"=>"22222222C",
                 "3_LAST_NAME_FIRST_NAME_MIDDLE_NAME_OF_VETERAN"=>"SNUFFY, JOE, R",
                 "4_INSURANCE_FILE_NO_OR_LOAN_NO"=>nil,
                 "8A_APPELLANT_REPRESENTED_IN_THIS_APPEAL_BY"=>"Disabled American Veterans - DAV",
                 "8B_POWER_OF_ATTORNEY"=>"",
                 "9A_IF_REPRESENTATIVE_IS_SERVICE_ORGANIZATION_IS_VA_FORM_646_YES"=>"",
                 "9A_IF_REPRESENTATIVE_IS_SERVICE_ORGANIZATION_IS_VA_FORM_646_NO"=>"",
                 "10A_WAS_HEARING_REQUESTED_YES"=>true,
                 "10A_WAS_HEARING_REQUESTED_NO"=>false,
                 "12A_DATE_STATEMENT_OF_THE_CASE_FURNISHED"=>"04/03/2012",
                 "12B_SUPPLEMENTAL_STATEMENT_OF_THE_CASE_REQUIRED_AND_FURNISHED"=>false,
                 "12B_SUPPLEMENTAL_STATEMENT_OF_THE_CASE_NOT_REQUIRED"=>true,
                 "15_NAME_AND_LOCATION_OF_CERTIFYING_OFFICE"=>"Waco, TX",
                 "16_ORGANIZATIONAL_ELEMENT_CERTIFIYING_APPEAL"=>"RO49",
                 "5A_SERVICE_CONNECTION_FOR"=>"DG5257 Knee, other impairment of:DG5215 Wrist, limitation of motion of",
                 "6A_INCREASED_RATING_FOR"=>"Increased rating:Increased rating",
                 "7A_OTHER"=>"TDIU:Overpayment",
                 "5B_DATE_OF_NOTIFICATION_OF_ACTION_APPEALED"=>"05/01/2013",
                 "6B_DATE_OF_NOTIFICATION_OF_ACTION_APPEALED"=>"05/01/2013",
                 "7B_DATE_OF_NOTIFICATION_OF_ACTION_APPEALED"=>"05/01/2013"},
            "required_fields"=>{"show_8b"=>true, "show_9a"=>true, "show_10b"=>true, "show_10c"=>true}}
    end
  end
end
