class Case < ActiveRecord::Base
  self.table_name = 'vacols.brieff'
  self.sequence_name = 'vacols.bfkeyseq'
  self.primary_key = 'bfkey'

  belongs_to :appellant, foreign_key: :bfcorkey, primary_key: :stafkey

  has_one :folder, foreign_key: :ticknum

  has_many :issues, -> { order 'issues.issseq asc' }, foreign_key: :isskey
  has_many :assignments, -> { order 'assign.tskdassn asc' }, foreign_key: :tsktknm
  has_many :attachments, -> { order 'attach.imgadtm asc' }, foreign_key: :imgtkky
end