require 'refinerycms-core'

module Refinery
  autoload :SaleoffCodesGenerator, 'generators/refinery/saleoff_codes_generator'

  module SaleoffCodes
    require 'refinery/saleoff_codes/engine'

    class << self
      attr_writer :root

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [ root.join('spec', 'factories').to_s ]
      end
    end
  end
end
