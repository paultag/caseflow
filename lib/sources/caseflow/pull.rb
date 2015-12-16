#!/usr/bin/env ruby
#
# Usage: pull.rb [bfcorlid...]
#
# Pull cases from VACOLS and put them into a JSON format that the Caseflow
# Fakes models can import as test data.
#
# This is useful when you need to debug bugs caused by data in the production
# webservice, *without* actually using the production VACOLS database. This
# will constuct a mock object that matches (as best as they can) the state
# of the production data.
#
# This script also queries the VBMS efolder to get the `nod`, `form9`, and `soc`
# dates.
#
# This information is still PII, and *must* be treated with care. Never check
# the output JSON into any VCS, and *destroy* the data as soon as it's not
# needed anymore. Do not take this information off your secured machine, and
# never put it into a system unapproved for PII, or a USB stick.

def dateize(date)
  if not date.nil?
    date.strftime("%Y-%m-%d")
  end
end

def main(argv)
  file_path = "imported-production-data-mocks.json"
  # The goal here is to be as anoying as we can with the filename.

  puts "Writing to #{file_path}"
  puts ""
  puts "export CASEFLOW_FAKES=\"#{file_path}\""
  puts ""

  data = Case.where(bfcorlid: argv)
  cases = data.map do
    |el| [el.bfkey, {bfkey: el.bfkey,
                     bfcorlid: el.bfcorlid,
                     bfac: el.bfac,
                     bfdc: el.bfdc,
                     bfmpro: el.bfmpro,
                     bfpdnum: el.bfpdnum,
                     bfregoff: "DSUSER", # We're going to move them into our RO
                     bfdrodec: dateize(el.bfdrodec),
                     bfdnod: dateize(el.bfdnod),
                     bfd19: dateize(el.bfd19),
                     bfdsoc: dateize(el.bfdsoc),
                     # Fake good and valid data here
                     efolder_nod: el.efolder_nod_date,
                     efolder_form9: el.efolder_form9_date,
                     efolder_soc: el.efolder_soc_date,
                     efolder_appellant_id: el.efolder_appellant_id,
                     # Now, fill out the rest.
                     appeal_type: el.appeal_type,
                     vso_full: el.vso_full,
                     regional_office_full: el.regional_office_full,
                     folder: el.folder.file_type,
                     correspondent: [
                         el.correspondent.appellant_name,
                         el.correspondent.appellant_relationship,
                         el.correspondent.full_name,
                         el.correspondent.snamef,
                         el.correspondent.snamemi,
                         el.correspondent.snamel
                     ],
                     issue_breakdown: el.issue_breakdown.map do
                         |el| {'field_type': el['field_type'],
                               'full_desc': el['full_desc']}
                     end,
                     bfso: el.bfso}]
  end
  File.open(file_path, 'w') do |f|
    f.write(cases.to_h.to_json)
  end
end

if __FILE__ == $0
  main(ARGV)
end
