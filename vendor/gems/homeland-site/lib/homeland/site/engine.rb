module Homeland::Site
  class Engine < ::Rails::Engine
    isolate_namespace Homeland::Site

    initializer 'homeland.site.init' do |app|
      next unless Setting.has_module?(:site)
      Homeland.register_plugin do |plugin|
        plugin.name = Homeland::Site::NAME
        plugin.display_name = '导航'
        plugin.version = Homeland::Site::VERSION
        plugin.description = Homeland::Site::DESCRIPTION
        plugin.navbar_link = true
        plugin.admin_navbar_link = true
        plugin.root_path = "/sites"
        plugin.admin_path = "/admin/sites"
      end

      app.routes.prepend do
        mount Homeland::Site::Engine => '/'
      end
      app.config.paths["db/migrate"].concat(config.paths["db/migrate"].expanded)
    end
  end
end
