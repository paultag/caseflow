class Attachment < ActiveRecord::Base
  self.table_name = 'vacols.attach'
  self.primary_key = 'imgkey'

  belongs_to :case, foreign_key: :imgtkky
  belongs_to :folder, foreign_key: :imgtkky
end