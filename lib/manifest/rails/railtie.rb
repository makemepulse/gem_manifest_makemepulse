require 'sprockets/railtie'

module ManifestMakemepulse::Rails

  class Railtie < ::Rails::Railtie

    config.manifest                 = ActiveSupport::OrderedOptions.new
    config.manifest.exclude         = [".js", ".erb",".css", ".scss", ".map", ".erb", "rails_admin/"]

    initializer :setup_manifest, group: :all do |app|

      config.manifest.output_location = File.join(Rails.root, "app/assets/javascripts/")
      config.manifest.output_file     = "assets-manifest.js.erb"

      if Rails.env.development?

        app.middleware.insert_before ::Rails::Rack::Logger, ::ManifestMakemepulse::Rails::CreateManifest

      end
    end

  end
end