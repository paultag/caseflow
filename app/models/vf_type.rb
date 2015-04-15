class VfType < ActiveRecord::Base
  self.table_name = 'vacols.vftypes'
  self.primary_key = :ftkey

  class << self
    def lookup(code)
      self.find('DG' + code.strip)
    end
  end
end