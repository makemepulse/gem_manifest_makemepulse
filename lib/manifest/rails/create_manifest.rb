
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

        puts ::Rails.application.assets.each_file

        manifest_config = ::Rails.application.config.manifest
        manifest_file   = File.join(manifest_config.output_location , manifest_config.output_file) 

        directory_glob = ::Rails.application.assets.each_file
          .select{|f| File.file?(f) && !manifest_config.exclude.include?(File.extname(f))}
          .map{|path| 
            ::Rails.application.assets.paths.each do |a_p|
              path.gsub!("#{a_p}/", "")
            end
            path
          }

        directory_stru = {}
        for el in directory_glob
          directory_stru[el] = {
                asset_path: "<%= asset_path('#{el}') %>",
                asset_url: "<%= asset_url('#{el}') %>"
              } 
        end


        File.open(manifest_file, 'w') do |file|
          file.puts "'use strict';\nwindow.manifest = #{JSON::dump(directory_stru)}"
        end
        finish = Time.now
        diff = finish - start
        puts "---------", "generate JS manifest in #{diff} sec", "------"
        @app.call(env)
      end
    end


  end

end