require 'rails_helper'

RSpec.describe PurchaseForm, type: :model do
  describe '配送先情報の保存' do
    before do
      @user = FactoryBot.create(:user)
      @item = FactoryBot.create(:item)
      @purchase_form = FactoryBot.build(:purchase_form, user_id:@user.id, item_id:@item.id)
      sleep(1)
    end

    context '配送先情報の保存ができるとき' do
      it 'すべての値が正しく入力されていれば保存できること' do
        expect(@purchase_form).to be_valid
      end

      it 'user_idが空でなければ保存できる' do
        @purchase_form.user_id = 1
        expect(@purchase_form).to be_valid
      end

      it 'item_idが空でなければ保存できる' do
        @purchase_form.item_id = 1
        expect(@purchase_form).to be_valid
      end

      it '郵便番号が「3桁+ハイフン+4桁」の組み合わせであれば保存できる' do
        @purchase_form.postal_code = '123-4560'
        expect(@purchase_form).to be_valid
      end

      it '都道府県が「---」以外かつ空でなければ保存できる' do
        @purchase_form.prefecture = 1
        expect(@purchase_form).to be_valid
      end

      it '市区町村が空でなければ保存できる' do
        @purchase_form.city = '横浜市'
        expect(@purchase_form).to be_valid
      end

      it '番地が空でなければ保存できる' do
        @purchase_form.house_number = '旭区１２３'
        expect(@purchase_form).to be_valid
      end

      it '建物名が空でも保存できる' do
        @purchase_form.building_name = nil
        expect(@purchase_form).to be_valid
      end

      it '電話番号が11桁以内かつハイフンなしであれば保存できる' do
        @purchase_form.tel = '12345678910'
        expect(@purchase_form).to be_valid
      end
    end

    context '配送先情報の保存ができないとき' do
      it 'user_idが空だと保存できない' do
        @purchase_form.user_id = nil
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("User can't be blank")
      end

      it 'item_idが空だと保存できない' do
        @purchase_form.item_id = nil
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("Item can't be blank")
      end

      it '郵便番号が空だと保存できないこと' do
        @purchase_form.postal_code = nil
        @purchase_form.valid?
        expect(@purchase_form.errors[:postal_code]).to include("郵便番号を正しい形式で入力してください")
      end

      it '郵便番号にハイフンがないと保存できないこと' do
        @purchase_form = PurchaseForm.new(postal_code: '1234567')
        @purchase_form.valid?
        expect(@purchase_form.errors[:postal_code]).to include("郵便番号を正しい形式で入力してください")
      end

      
      it '都道府県が「---」だと保存できないこと' do
        @purchase_form.prefecture = 0
        @purchase_form.valid?
        expect(@purchase_form.errors[:prefecture]).to include('都道府県を選択してください')
      end
      
      
      
      

      it '都道府県が空だと保存できないこと' do
        @purchase_form.prefecture = nil
        @purchase_form.valid?
        expect(@purchase_form.errors[:prefecture]).to include("can't be blank")
      end

      it '市区町村が空だと保存できないこと' do
        @purchase_form.city = nil
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("City 市区町村を入力してください")
      end
      

      it '番地が空だと保存できないこと' do
        @purchase_form.house_number = nil
        @purchase_form.valid?
        expect(@purchase_form.errors[:house_number]).to include("番地を入力してください")
      end
      
      
      it '電話番号が空だと保存できないこと' do
        @purchase_form = PurchaseForm.new(tel: nil)
        @purchase_form.valid?
        expect(@purchase_form.errors[:tel]).to include("電話番号は10桁以上11桁以内の半角数値で入力してください")
      end
      

      it '電話番号にハイフンがあると保存できないこと' do
        @purchase_form.tel = '123-1234-1234'
        @purchase_form.valid?
        expect(@purchase_form.errors[:tel]).to include('電話番号は10桁以上11桁以内の半角数値で入力してください')
      end

      it '電話番号が12桁以上あると保存できないこと' do
        @purchase_form = PurchaseForm.new(tel: '12345678910123111')
        @purchase_form.valid?
        expect(@purchase_form.errors[:tel]).to include('電話番号は10桁以上11桁以内の半角数値で入力してください')
      end

      it '電話番号が9桁以下だと保存できないこと' do
        @purchase_form.tel = '123456789'
        @purchase_form.valid?
        expect(@purchase_form.errors[:tel]).to include('電話番号は10桁以上11桁以内の半角数値で入力してください')
      end

      it 'トークンが空だと保存できないこと' do
        @purchase_form.token = nil
        @purchase_form.valid?
        expect(@purchase_form.errors[:token]).to include("クレジットカード情報を入力してください")
      end    
    end
  end
end