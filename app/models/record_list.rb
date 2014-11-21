class RecordList < ActiveRecord::Base
  self.table_name = 'vacols.othdocs'
  self.primary_key = nil # no primary key for this table

  belongs_to :case, foreign_key: :ticknum
  belongs_to :folder, foreign_key: :ticknum
end