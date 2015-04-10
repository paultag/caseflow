module Api
  class CertificationsController < ApiController
    def start
      data = {}
      kase = Case.find(params[:id])

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
          appeal_type: kase.appeal_type,
          file_type: kase.folder.file_type
      }

      data[:fields] = kase.initial_fields

      render json: data
    end
  end
end
