class RemandReason < ActiveRecord::Base
  self.table_name = 'vacols.rmdrea'
  self.primary_keys = :rmdkey, :rmdissseq

  belongs_to :case, foreign_key: :rmdkey
  belongs_to :folder, foreign_key: :rmdkey
end