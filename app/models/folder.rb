class Folder < ActiveRecord::Base
  self.table_name = 'vacols.folder'
  self.primary_key = :ticknum

  belongs_to :appellant, foreign_key: :ticorkey, primary_key: :stafkey

  has_one :case, foreign_key: :bfkey

  has_many :issues, -> { order 'issues.issseq asc' }, foreign_key: :isskey
  has_many :assignments, -> { order 'assign.tskdassn asc' }, foreign_key: :tsktknm
  has_many :attachments, -> { order 'attach.imgadtm asc' }, foreign_key: :imgtkky
end