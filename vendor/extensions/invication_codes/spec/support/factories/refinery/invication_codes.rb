
FactoryGirl.define do
  factory :invication_code, :class => Refinery::InvicationCodes::InvicationCode do
    sequence(:code) { |n| "refinery#{n}" }
  end
end

