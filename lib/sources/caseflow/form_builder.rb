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

  def initialize(fields = {})
    self.fields = self.class.field_legend.reduce({}) do |memo, (name, value)|
      case value[:type]
        when :text
          memo[name] = ''
        when :check
          memo[name] = false
        when :radio
          # no action
        else
          memo[name] = nil
      end
      memo
    end

    self.add_fields(fields)
  end

  def values
    self.class.field_legend.reduce({}) do |memo, (name, attr)|
      case attr[:type]
        when :check
          case fields[name]
            when true, 'true', 'yes', '1', 1
              # pdf files seem to need a special character for checkboxes, which is chosen when made
              # if check_symbol is provided, use that for a truthy value; else use what was passed
              memo[attr[:id]] = self.class.check_symbol || fields[name]
            else
              # just leave blank to keep unchecked
          end
        when :radio
          case fields[name]
            when nil
              # check neither
            when true, 'true', 'yes', '1', 1
              f = self.class.field_legend[name + '_YES']

              memo[f[:id]] = self.class.check_symbol || fields[name]
            else
              f = self.class.field_legend[name + '_NO']

              memo[f[:id]] = self.class.check_symbol || fields[name]
            end
        else
          memo[attr[:id]] = fields[name]
      end
      memo
    end
  end

  def add_fields(new_fields)
    self.fields.merge!(new_fields)
  end

  def file_name
    @file_name ||= "#{self.class.form_name}-#{SecureRandom.hex}.pdf"
  end

  def tmp_location
    Rails.root + 'tmp' + 'forms' + "#{file_name}.tmp"
  end

  def final_location
    Rails.root + 'tmp' + 'forms' + file_name
  end

  def process!
    self.engine.fill_form((Rails.root + 'forms' + "#{self.class.form_name}.pdf"), self.tmp_location, self.values, flatten: true)
    # Run it through `pdftk cat`. The reason for this is that editable PDFs have
    # an RSA signature on them which proves they are genuine. pdftk tries to
    # maintain the editability of a PDF after processing it, but then the
    # signature doesn't match. The result is that (without `pdftk cat`) Acrobat
    # shows a warning (other PDF viewers don't care).
    self.engine.call_pdftk(self.tmp_location, "cat", "output", self.final_location)
  end
end
