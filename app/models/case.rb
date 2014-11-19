class Case < ActiveRecord::Base
  self.table_name = 'vacols.brieff'
  self.sequence_name = 'vacols.bfkeyseq'
  self.primary_key = 'bfkey'

  belongs_to :appellant, foreign_key: :bfcorkey, primary_key: :stafkey

  has_one :folder, foreign_key: :ticknum

  has_many :issues, foreign_key: :isskey
end