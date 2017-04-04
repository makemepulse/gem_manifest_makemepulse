require 'sprockets/railtie'

module ManifestMakemepulse::Rails

  class Railtie < ::Rails::Railtie

    config.manifest                 = ActiveSupport::OrderedOptions.new
    config.manifest.auto_refresh    = false

    initializer :setup_manifest, group: :all do |app|


      config.manifest.input_location  = File.join(Rails.root, "app/assets/images/")
      config.manifest.output_location = File.join(Rails.root, "app/assets/javascripts/")
      config.manifest.output_file     = "tmp-assets-manifest.js.erb"

      if Rails.env.development?

        app.config.manifest.auto_refresh = true
        app.middleware.insert_before ::Rails::Rack::Logger, ::ManifestMakemepulse::Rails::CreateManifest

      end
    end

  end
end