# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "SaleoffCodes" do
    describe "Admin" do
      describe "saleoff_codes" do
        login_refinery_user

        describe "saleoff_codes list" do
          before do
            FactoryGirl.create(:saleoff_code, :code => "UniqueTitleOne")
            FactoryGirl.create(:saleoff_code, :code => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.saleoff_codes_admin_saleoff_codes_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.saleoff_codes_admin_saleoff_codes_path

            click_link "Add New Saleoff Code"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Code", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::SaleoffCodes::SaleoffCode.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Code can't be blank")
              Refinery::SaleoffCodes::SaleoffCode.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:saleoff_code, :code => "UniqueTitle") }

            it "should fail" do
              visit refinery.saleoff_codes_admin_saleoff_codes_path

              click_link "Add New Saleoff Code"

              fill_in "Code", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::SaleoffCodes::SaleoffCode.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:saleoff_code, :code => "A code") }

          it "should succeed" do
            visit refinery.saleoff_codes_admin_saleoff_codes_path

            within ".actions" do
              click_link "Edit this saleoff code"
            end

            fill_in "Code", :with => "A different code"
            click_button "Save"

            page.should have_content("'A different code' was successfully updated.")
            page.should have_no_content("A code")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:saleoff_code, :code => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.saleoff_codes_admin_saleoff_codes_path

            click_link "Remove this saleoff code forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::SaleoffCodes::SaleoffCode.count.should == 0
          end
        end

      end
    end
  end
end
