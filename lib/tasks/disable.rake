desc 'Raises exception if used'
task disable: [:environment] do
  raise 'You cannot run this'
end
