class Issue < ActiveRecord::Base
  self.table_name = 'vacols.issues'
  self.primary_keys = :isskey, :issseq

  belongs_to :case, foreign_key: :isskey
  belongs_to :folder, foreign_key: :isskey
end