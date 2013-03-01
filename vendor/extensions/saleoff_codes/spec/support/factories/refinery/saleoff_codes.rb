
FactoryGirl.define do
  factory :saleoff_code, :class => Refinery::SaleoffCodes::SaleoffCode do
    sequence(:code) { |n| "refinery#{n}" }
  end
end

