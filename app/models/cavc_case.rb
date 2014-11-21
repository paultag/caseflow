class CavcCase < ActiveRecord::Base
  self.table_name = 'vacols.cova'
  self.primary_key = 'cvfolder'

  has_one :case, foreign_key: :bfkey
  has_one :folder, foreign_key: :ticknum
end