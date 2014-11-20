class Assignment < ActiveRecord::Base
  self.table_name = 'vacols.assign'
  self.primary_key = 'tasknum'

  belongs_to :case, foreign_key: :tsktknm
  belongs_to :folder, foreign_key: :tsktknm
end