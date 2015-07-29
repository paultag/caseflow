['db:create', 'db:create:all', 'db:drop', 'db:drop:all', 'db:migrate',
 'db:migrate:down', 'db:migrate:redo', 'db:migrate:reset', 'db:migrate:up', 'db:reset', 'db:rollback',
 'db:schema:dump', 'db:schema:load', 'db:seed', 'db:setup', 'db:structure:dump', 'db:test:prepare'].each do |t|
  Rake::Task[t].enhance ['disable']
end
