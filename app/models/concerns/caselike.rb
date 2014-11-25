module Caselike
  extend ActiveSupport::Concern

  included do
    has_one :cavc_case, foreign_key: :cvfolder
    has_one :record_list, foreign_key: :ticknum

    has_many :issues, -> { order 'issues.issseq asc' }, foreign_key: :isskey
    has_many :assignments, -> { order 'assign.tskdassn asc' }, foreign_key: :tsktknm
    has_many :attachments, -> { order 'attach.imgadtm asc' }, foreign_key: :imgtkky
    has_many :hearings, -> { order 'hearsched.hearing_date asc' }, foreign_key: :folder_nr
    has_many :correspondences, -> { order 'mail.mlseq asc' }, foreign_key: :mlfolder
    has_many :prior_staff_locations, -> { order 'priorloc.locdin desc nulls first' }, class: PriorStaffLocation, foreign_key: :lockey
    has_many :remand_reasons, -> { order 'rmdrea.rmdissseq asc' }, foreign_key: :rmdkey
    has_many :representatives, -> { order 'rep.repaddtime desc' }, foreign_key: :repkey
  end
end