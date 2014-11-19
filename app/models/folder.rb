class Folder < ActiveRecord::Base
  self.table_name = 'vacols.folder'
  self.primary_key = :ticknum

  has_one :case, foreign_key: :bfkey
end