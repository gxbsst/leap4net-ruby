require 'spec_helper'

module Refinery
  module InvicationCodes
    describe InvicationCode do
      describe "validations" do
        subject do
          FactoryGirl.create(:invication_code,
          :code => "Refinery CMS")
        end

        it { should be_valid }
        its(:errors) { should be_empty }
        its(:code) { should == "Refinery CMS" }
      end
    end
  end
end
