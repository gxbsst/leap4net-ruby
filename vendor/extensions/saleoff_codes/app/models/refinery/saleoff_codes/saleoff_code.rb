module Refinery
  module SaleoffCodes
    class SaleoffCode < Refinery::Core::BaseModel
      self.table_name = 'refinery_saleoff_codes'

      attr_accessible :begin_at, :end_at, :code, :percent, :user_id, :position

      acts_as_indexed :fields => [:code]

      validates :code, :presence => true, :uniqueness => true

      def available?
        Time.now < self.end_at && Time.now >self.begin_at
      end

    end
  end
end


