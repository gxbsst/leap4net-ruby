module Refinery
  module InvicationCodes
    class Engine < Rails::Engine
      include Refinery::Engine
      isolate_namespace Refinery::InvicationCodes

      engine_name :refinery_invication_codes

      initializer "register refinerycms_invication_codes plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.name = "invication_codes"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.invication_codes_admin_invication_codes_path }
          plugin.pathname = root
          plugin.activity = {
            :class_name => :'refinery/invication_codes/invication_code',
            :title => 'code'
          }
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::InvicationCodes)
      end
    end
  end
end
