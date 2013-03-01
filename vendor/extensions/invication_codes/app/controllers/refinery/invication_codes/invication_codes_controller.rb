module Refinery
  module InvicationCodes
    class InvicationCodesController < ::ApplicationController

      before_filter :find_all_invication_codes
      before_filter :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @invication_code in the line below:
        present(@page)
      end

      def show
        @invication_code = InvicationCode.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @invication_code in the line below:
        present(@page)
      end

    protected

      def find_all_invication_codes
        @invication_codes = InvicationCode.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/invication_codes").first
      end

    end
  end
end
