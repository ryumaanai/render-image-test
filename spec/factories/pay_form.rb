FactoryBot.define do
  factory :pay_form do
    token { 'sampletokensampletoken' }
    postal_code { '123-4567' }
    prefecture { 1 }
    city { '東京都' }
    addresses { '1-1' }
    building { 'テックキャンプビル' }
    phone_number { '09012345678' }
  end
end
