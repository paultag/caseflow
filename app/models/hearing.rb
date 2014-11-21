class Hearing < ActiveRecord::Base
  self.table_name = 'vacols.hearsched'
  self.sequence_name = 'vacols.hearsched_pkseq'
  self.primary_key = 'hearing_pkseq'

  belongs_to :case, foreign_key: :folder_nr
  belongs_to :folder, foreign_key: :folder_nr
end