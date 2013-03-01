module Refinery
  module SaleoffCodes
    module Admin
      class SaleoffCodesController < ::Refinery::AdminController

        crudify :'refinery/saleoff_codes/saleoff_code',
                :title_attribute => 'code', :xhr_paging => true

      end
    end
  end
end
