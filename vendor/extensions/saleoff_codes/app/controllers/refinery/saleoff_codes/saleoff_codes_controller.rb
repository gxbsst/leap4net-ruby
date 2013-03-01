module Refinery
  module SaleoffCodes
    class SaleoffCodesController < ::ApplicationController

      before_filter :find_all_saleoff_codes
      before_filter :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @saleoff_code in the line below:
        present(@page)
      end

      def show
        @saleoff_code = SaleoffCode.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @saleoff_code in the line below:
        present(@page)
      end

    protected

      def find_all_saleoff_codes
        @saleoff_codes = SaleoffCode.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/saleoff_codes").first
      end

    end
  end
end
