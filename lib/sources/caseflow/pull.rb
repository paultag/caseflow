#!/usr/bin/env ruby

def dateize(date)
  if not date.nil?
    date.strftime("%Y-%m-%d")
  end
end

def main(argv)
  file_path = argv.shift
  puts "Writing to #{file_path}"
  puts ""
  puts "export CASEFLOW_FAKES=\"#{file_path}\""
  puts ""

  data = Case.where(bfcorlid: argv)
  cases = data.map do
    |el| [el.bfkey, {bfkey: el.bfkey,
                     bfcorlid: el.bfcorlid,
                     bfac: el.bfac,
                     bfmpro: el.bfmpro,
                     bfpdnum: el.bfpdnum,
                     bfregoff: "DSUSER", # We're going to move them into our RO
                     bfdrodec: dateize(el.bfdrodec),
                     bfdnod: dateize(el.bfdnod),
                     bfd19: dateize(el.bfd19),
                     bfdsoc: dateize(el.bfdsoc),
                     # Fake good and valid data here
                     efolder_nod: dateize(el.bfdnod),
                     efolder_form9: dateize(el.bfd19),
                     efolder_soc: dateize(el.bfdsoc),
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
