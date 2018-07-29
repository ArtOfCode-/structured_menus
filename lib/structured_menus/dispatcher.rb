module StructuredMenus
  class Dispatcher
    def initialize
      menus_dir = StructuredMenus.config.menus_directory
      @menus = Dir.entries(menus_dir).reject { |f| File.directory? f }\
                                     .map { |p| [File.basename(p).gsub('.yml', ''), p] }.to_h.with_indifferent_access
      @adapters = StructuredMenus.config.adapters.map do |an|
        if an.class == Class
          an
        elsif an.class == String
          require_relative an
          File.basename(an).gsub('.rb', '').classify.constantize
        end
      end.map { |ac| [ac.name.demodulize.gsub('Adapter', '').underscore, ac] }.to_h.with_indifferent_access
    end

    def show(name, adapter_name, user, **options)
      menu = YAML.safe_load(File.read(StructuredMenus.config.menus_directory.join(@menus[name])))
      adapter = @adapters[adapter_name]
      adapter.show(menu, user, **options)
    end
  end
end