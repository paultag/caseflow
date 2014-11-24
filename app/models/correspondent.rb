class Correspondent < ActiveRecord::Base
  self.table_name = 'vacols.corres'
  self.primary_key = 'stafkey'

  has_many :types, class_name: 'AppellantType', foreign_key: :ctypkey

  has_many :cases, foreign_key: :bfcorkey
  has_many :folders, foreign_key: :ticorkey
  has_many :correspondences, -> { order 'mail.mlcorrdate asc' }, foreign_key: :mlcorkey

  has_many :hearings, through: :cases
end