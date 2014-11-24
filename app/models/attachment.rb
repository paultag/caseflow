class Attachment < ActiveRecord::Base
  self.table_name = 'vacols.attach'
  self.primary_key = 'imgkey'

  belongs_to :case, foreign_key: :imgtkky
  belongs_to :folder, foreign_key: :imgtkky

  belongs_to :assigned_to, class: StaffLocation, foreign_key: :imgowner
  belongs_to :attached_by, class: StaffLocation, foreign_key: :imgadusr
  belongs_to :changed_by, class: StaffLocation, foreign_key: :imgmdusr
end