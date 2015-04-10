class Folder < ActiveRecord::Base
  include Caselike

  self.table_name = 'vacols.folder'
  self.primary_key = 'ticknum'

  belongs_to :correspondent, foreign_key: :ticorkey, primary_key: :stafkey

  belongs_to :added_by, class: StaffLocation, foreign_key: :tiaduser
  belongs_to :changed_by, class: StaffLocation, foreign_key: :timduser

  has_one :case, foreign_key: :bfkey

  def file_type
    if ['Y', '1', '0'].include?(tivbms)
      'VBMS'
    elsif tisubj == 'Y'
      'VVA'
    else
      'Paper'
    end
  end

  def paperless?
    [:vbms, :vva].include?(file_type)
  end
end