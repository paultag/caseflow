module Api
  class CertificationsController < ApiController
    def start
      kase = get_case(params[:id])

      data = {}
      data[:info] = {
          bfkey: kase.bfkey,
          bfcorlid: kase.bfcorlid,
          bfac: kase.bfac,
          bfmpro: kase.bfmpro,
          bfdnod: kase.bfdnod_date,
          bfd19: kase.bfd19_date,
          bfdsoc: kase.bfdsoc_date,
          bfssoc1: kase.bfssoc1_date,
          bfssoc2: kase.bfssoc2_date,
          bfssoc3: kase.bfssoc3_date,
          bfssoc4: kase.bfssoc4_date,
          bfssoc5: kase.bfssoc5_date,

          efolder_nod: kase.efolder_nod_date,
          efolder_form9: kase.efolder_form9_date,
          efolder_soc: kase.efolder_soc_date,
          efolder_ssoc1: kase.efolder_ssoc1_date,
          efolder_ssoc2: kase.efolder_ssoc2_date,
          efolder_ssoc3: kase.efolder_ssoc3_date,
          efolder_ssoc4: kase.efolder_ssoc4_date,
          efolder_ssoc5: kase.efolder_ssoc5_date,
          efolder_id: kase.efolder_appellant_id,

          appeal_type: kase.appeal_type,
          file_type: kase.folder.file_type
      }

      data[:fields] = kase.initial_fields

      data[:required_fields] = kase.required_fields

      render json: data
    end

    def generate
      certification_date = Time.now.to_s(:va_date)

      fields = params[:fields]
      fields['17C_DATE'] = certification_date

      form_8 = FormVa8.new(params[:fields])
      form_8.process!

      render json: {status: 'ok', file_name: form_8.file_name, bf41stat: certification_date}, status: :created
    end

    def certify
      kase = get_case(params[:id])

      corr = kase.correspondent

      Case.transaction do
        kase.bfdcertool = Time.now
        kase.bf41stat   = Date.strptime(params[:cert][:certification_date], Date::DATE_FORMATS[:va_date])
        kase.save

        kase.efolder_case.upload_form8(corr.snamef, corr.snamemi, corr.snamel, params[:cert][:file_name])
      end

      render json: {status: 'ok', bf41stat: kase.bf41stat.to_s(:va_date)}, status: :created
    end
  end
end
