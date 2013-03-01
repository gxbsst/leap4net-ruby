module Refinery
  module InvicationCodes
    class InvicationCode < Refinery::Core::BaseModel
      self.table_name = 'refinery_invication_codes'

      attr_accessible :begin_at, :end_at, :code, :user_type, :user_id, :position

      acts_as_indexed :fields => [:code, :user_type]

      validates :code, :presence => true, :uniqueness => true
    end
  end
end
