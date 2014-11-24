class AppellantType < ActiveRecord::Base
  self.table_name = 'vacols.corrtyps'
  self.primary_keys = :ctypkey, :ctypval

  belongs_to :correspondent, foreign_key: :ctypkey
end