
module ManifestMakemepulse::Rails

  class CreateManifest

    def initialize(app)
      @app          = app
      @assets_regex = %r(\A/{0,2}#{::Rails.application.config.assets.prefix})
    end

    def call(env)

      if env['PATH_INFO'] =~ @assets_regex
        @app.call(env)
      else
        start = Time.now
        puts "generate JS manifest"
        manifest_config = ::Rails.application.config.manifest
        
        manifest_file   = File.join(manifest_config.output_location , manifest_config.output_file) 
        assets_folder   = File.join(::Rails.root, "assets", "images")

        directory_glob = Dir.glob(File.join(manifest_config.input_location, "**/*"))
          .map{|path| path.gsub(manifest_config.input_location, "")}
          .map{|path| path.split '/' }
          .inject({}){|acc, path| path.inject(acc) do |acc2,dir| 
            
            if File.extname(dir).empty?
              acc2[dir] ||= {}
            else
              acc2[dir] ||= {
                asset_path: "<%= asset_path('#{path.join("/")}') %>",
                asset_url: "<%= asset_url('#{path.join("/")}') %>"
              } 
            end
            acc2[dir]
          end
          acc  }

        File.open(manifest_file, 'w') do |file|
          file.puts "'use strict';\nwindow.manifest = #{JSON::dump(directory_glob)}"
        end
        finish = Time.now
        diff = finish - start
        puts "---------", "generate JS manifest in #{diff} sec", "------"
        @app.call(env)
      end
    end


  end

end