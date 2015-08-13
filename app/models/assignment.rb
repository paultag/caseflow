class Assignment < ActiveRecord::Base
  self.table_name = 'vacols.assign'
  self.primary_key = 'tasknum'

  belongs_to :case, foreign_key: :tsktknm
  belongs_to :folder, foreign_key: :tsktknm

  belongs_to :assigned_to, class_name: StaffLocation, foreign_key: :tskstfas
  belongs_to :added_by, class_name: StaffLocation, foreign_key: :tskadusr
  belongs_to :owned_by, class_name: StaffLocation, foreign_key: :tskstown
  belongs_to :changed_by, class_name: StaffLocation, foreign_key: :tskmdusr

  # belongs_to :attachment
  # belongs_to :hearing
  # belongs_to :prior_location
end
