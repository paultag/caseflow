require 'pdf_forms'

class Caseflow::FormBuilder
  @@engine = PdfForms.new(`which pdftk`.chomp)

  cattr_reader :engine

  attr_accessor :fields

  class << self
    attr_accessor :form_name
    attr_accessor :check_symbol
    attr_accessor :field_legend
  end

  def initialize
    self.fields = self.class.field_legend.reduce({}) do |memo, (name, value)|
      case value[:type]
        when :text
          memo[name] = ''
        when :check
          memo[name] = false
        else
          memo[name] = nil
      end
      memo
    end
  end

  def values
    self.class.field_legend.reduce({}) do |memo, (name, attr)|
      if attr[:type] == :check
        case fields[name]
          when true, 'true', 'yes', '1', 1
            memo[attr[:id]] = self.class.check_symbol
          else
            # leave blank to keep unchecked
        end
      else
        memo[attr[:id]] = fields[name]
      end
      memo
    end
  end

  def process!
    self.engine.fill_form((Rails.root + 'forms' + "#{self.class.form_name}.pdf"), (Rails.root + 'filled.pdf'), self.values, flatten: true)
  end

  private

  def temp_location
    Rails.root + 'tmp' + 'forms' + 
  end
end