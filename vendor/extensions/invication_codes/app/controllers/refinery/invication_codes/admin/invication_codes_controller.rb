module Refinery
  module InvicationCodes
    module Admin
      class InvicationCodesController < ::Refinery::AdminController

        crudify :'refinery/invication_codes/invication_code',
                :title_attribute => 'code', :xhr_paging => true

      end
    end
  end
end
