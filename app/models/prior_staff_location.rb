class PriorStaffLocation < ActiveRecord::Base
  self.table_name = 'vacols.priorloc'
  self.primary_key = nil # no primary key for this table

  belongs_to :case, foreign_key: :lockey
  belongs_to :folder, foreign_key: :lockey

  has_one :sent_by, class_name: StaffLocation, foreign_key: :stafkey, primary_key: :locstto
  has_one :received_by, class_name: StaffLocation, foreign_key: :stafkey, primary_key: :locstrcv
  has_one :checked_out_by, class_name: StaffLocation, foreign_key: :stafkey, primary_key: :locstout
end
