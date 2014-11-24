class StaffLocation < ActiveRecord::Base
  self.table_name = 'vacols.staff'
  self.primary_key = 'stafkey'

  has_many :all_assignments, class: Assignment, foreign_key: :tskstfas
  has_many :open_assignments, -> { where 'tskdcls is null' }, class: Assignment, foreign_key: :tskstfas
  has_many :closed_assignments, -> { where 'tskdcls is not null' }, class: Assignment, foreign_key: :tskstfas

  has_many :added_assignments, class: Assignment, foreign_key: :tskadusr
  has_many :owned_assignments, class: Assignment, foreign_key: :tskstown
  has_many :changed_assignments, class: Assignment, foreign_key: :tskmdusr

  has_many :attachments, foreign_key: :imgowner
  has_many :added_attachments, class: Attachment, foreign_key: :imgadusr
  has_many :changed_attachments, class: Attachment, foreign_key: :imgmdusr

  has_many :current_cases, class: Case, foreign_key: :bfcurloc
end