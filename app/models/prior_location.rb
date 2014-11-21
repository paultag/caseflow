class PriorLocation < ActiveRecord::Base
  self.table_name = 'vacols.priorloc'
  self.primary_key = nil # no primary key for this table

  belongs_to :case, foreign_key: :lockey
  belongs_to :folder, foreign_key: :lockey
end