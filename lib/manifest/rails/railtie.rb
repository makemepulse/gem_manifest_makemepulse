require 'sprockets/railtie'

module ManifestMakemepulse::Rails

  class Railtie < ::Rails::Railtie

    config.manifest                 = ActiveSupport::OrderedOptions.new
    config.manifest.exclude         = [".js", ".erb", ".css", ".map", ".erb"]

    initializer :setup_manifest, group: :all do |app|


      config.manifest.input_location  = File.join(Rails.root, "app/assets/")
      config.manifest.output_location = File.join(Rails.root, "app/assets/javascripts/")
      config.manifest.output_file     = "tmp-assets-manifest.js.erb"

      if Rails.env.development?

        app.middleware.insert_before ::Rails::Rack::Logger, ::ManifestMakemepulse::Rails::CreateManifest

      end
    end

  end
end