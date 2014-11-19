class Appellant < ActiveRecord::Base
  self.table_name = 'vacols.corres'
  self.primary_key = 'stafkey'

  has_many :cases, foreign_key: :bfcorkey
  has_many :folders, foreign_key: :ticorkey
end