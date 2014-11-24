class Correspondence < ActiveRecord::Base
  self.table_name = 'vacols.mail'
  self.primary_key = :mlfolder, :mlseq

  belongs_to :appellant, foreign_key: :mlcorkey

  belongs_to :case, foreign_key: :mlfolder
  belongs_to :folder, foreign_key: :mlfolder
end