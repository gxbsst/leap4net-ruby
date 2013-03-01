module Refinery
  module SaleoffCodes
    class Engine < Rails::Engine
      include Refinery::Engine
      isolate_namespace Refinery::SaleoffCodes

      engine_name :refinery_saleoff_codes

      initializer "register refinerycms_saleoff_codes plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.name = "saleoff_codes"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.saleoff_codes_admin_saleoff_codes_path }
          plugin.pathname = root
          plugin.activity = {
            :class_name => :'refinery/saleoff_codes/saleoff_code',
            :title => 'code'
          }
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::SaleoffCodes)
      end
    end
  end
end
