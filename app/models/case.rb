class Case < ActiveRecord::Base
  include Caselike

  self.table_name = 'vacols.brieff'
  self.sequence_name = 'vacols.bfkeyseq'
  self.primary_key = 'bfkey'

  belongs_to :correspondent, foreign_key: :bfcorkey, primary_key: :stafkey

  has_one :folder, foreign_key: :ticknum
  has_one :current_staff_location, class: StaffLocation, foreign_key: :stafkey, primary_key: :bfcurloc

  has_many :correspondences, foreign_key: :mlfolder
end