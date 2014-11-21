class Folder < ActiveRecord::Base
  include Caselike

  self.table_name = 'vacols.folder'
  self.primary_key = 'ticknum'

  belongs_to :appellant, foreign_key: :ticorkey, primary_key: :stafkey

  has_one :case, foreign_key: :bfkey
end