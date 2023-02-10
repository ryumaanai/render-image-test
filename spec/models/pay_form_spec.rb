require 'rails_helper'

RSpec.describe PayForm, type: :model do
  before do
    buyer = FactoryBot.create(:user)
    seller = FactoryBot.create(:user)
    item = FactoryBot.build(:item, user_id: seller.id)
    item.save
    @pay_form = FactoryBot.build(:pay_form, user_id: buyer.id, item_id: item.id)
  end

  describe '商品購入' do
    context '内容に問題ない場合' do
      it '全て正常' do
        expect(@pay_form).to be_valid
      end
      it 'buildingが空でも購入できる' do
        @pay_form.building = ''
        expect(@pay_form).to be_valid
      end
    end
    context '内容に問題がある場合' do
      it 'token:必須' do
        @pay_form.token = ''
        @pay_form.valid?
        expect(@pay_form.errors.full_messages).to include("Token can't be blank")
      end
      it 'postal_code:必須' do
        @pay_form.postal_code = ''
        @pay_form.valid?
        expect(@pay_form.errors.full_messages).to include("Postal code can't be blank")
      end
      it 'postal_code:フォーマット' do
        @pay_form.postal_code = '1234567'
        @pay_form.valid?
        expect(@pay_form.errors.full_messages).to include("Postal code is invalid. Enter it as follows (e.g. 123-4567)")
      end
      it 'prefecture:0以外' do
        @pay_form.prefecture = 0
        @pay_form.valid?
        expect(@pay_form.errors.full_messages).to include("Prefecture can't be blank")
      end
      it 'city:必須' do
        @pay_form.city = ''
        @pay_form.valid?
        expect(@pay_form.errors.full_messages).to include("City can't be blank")
      end
      it 'addresses:必須' do
        @pay_form.addresses = ''
        @pay_form.valid?
        expect(@pay_form.errors.full_messages).to include("Addresses can't be blank")
      end
      it 'phone_number:必須' do
        @pay_form.phone_number = ''
        @pay_form.valid?
        expect(@pay_form.errors.full_messages).to include("Phone number can't be blank")
      end
      it 'phone_number:10桁以上' do
        @pay_form.phone_number = '123456789'
        @pay_form.valid?
        expect(@pay_form.errors.full_messages).to include("Phone number is too short")
      end
      it 'phone_number:11桁以下' do
        @pay_form.phone_number = '123456789101'
        @pay_form.valid?
        expect(@pay_form.errors.full_messages).to include("Phone number is too long")
      end
      it 'phone_number:数字のみ' do
        @pay_form.phone_number = '123-567-890'
        @pay_form.valid?
        expect(@pay_form.errors.full_messages).to include("Phone number is invalid. Input only number")
      end
      it 'item_id:必須' do
        @pay_form.item_id = nil
        @pay_form.valid?
        expect(@pay_form.errors.full_messages).to include("Item can't be blank")
      end
      it 'user_id:必須' do
        @pay_form.user_id = nil
        @pay_form.valid?
        expect(@pay_form.errors.full_messages).to include("User can't be blank")
      end
    end
  end
end
