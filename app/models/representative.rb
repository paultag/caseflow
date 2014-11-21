class Representative < ActiveRecord::Base
  self.table_name = 'vacols.rep'
  self.primary_key = nil # no primary key for this table

  belongs_to :case, foreign_key: :repkey
  belongs_to :folder, foreign_key: :repkey
end