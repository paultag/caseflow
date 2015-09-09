# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

Rails.application.assets.register_engine('.haml', Tilt::HamlTemplate)

module Haml::Helpers
  def render_file(filename, args={})
    contents = File.read(Rails.root.join("app", "assets", "templates", filename + ".html.haml"))
    Haml::Engine.new(contents).render(Object.new, args)
  end
end

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
