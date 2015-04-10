class Correspondent < ActiveRecord::Base
  self.table_name = 'vacols.corres'
  self.primary_key = 'stafkey'

  has_many :types, class_name: 'AppellantType', foreign_key: :ctypkey

  has_many :cases, foreign_key: :bfcorkey
  has_many :folders, foreign_key: :ticorkey
  has_many :correspondences, -> { order 'mail.mlcorrdate asc' }, foreign_key: :mlcorkey

  has_many :hearings, through: :cases

  def full_name
    [snamel, snamef, snamemi].select(&:present?).join(', ')
  end

  def veteran_is_appellant?
    sspare1.present?
  end

  def appellant_name
    if veteran_is_appellant?
      [sspare1, sspare2, sspare3].select(&:present?).join(', ')
    end
  end

  def appellant_relationship
    if veteran_is_appellant?
      susrtyp
    end
  end
end