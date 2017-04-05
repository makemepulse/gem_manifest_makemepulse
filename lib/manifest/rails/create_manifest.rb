
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

        manifest_config = ::Rails.application.config.manifest
        manifest_file   = File.join(manifest_config.output_location , manifest_config.output_file) 
        
        puts manifest_config.exclude

        directory_glob = ::Rails.application.assets.each_file
          .select{ |f| File.file?(f) && !manifest_config.exclude.include?(File.extname(f))}
          .select{ |f| File.file?(f) && !manifest_config.exclude.include?(File.basename(f))}
          .map{|path| 
            ::Rails.application.assets.paths.each do |a_p|
              path.gsub!("#{a_p}/", "")
            end
            path
          }


        directory_stru = {}
        for el in directory_glob
          if !find_in_exclude(manifest_config.exclude, el)
            directory_stru[el] = {
                  asset_path: "<%= asset_path('#{el}') %>",
                  asset_url: "<%= asset_url('#{el}') %>"
                } 
          end
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

    def find_in_exclude(exclude, element)
      item_find = false
      exclude.each do |ex| 
        if element.index(ex) == 0
          item_find = true
          break
        end
      end
      return item_find
    end


  end

end