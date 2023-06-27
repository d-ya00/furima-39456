class OrdersController < ApplicationController
  def index
    @purchase_form = PurchaseForm.new
    @item = Item.find(params[:item_id])
  end

  def create
    binding.pry
    @purchase_form = PurchaseForm.new(purchase_params)
    @purchase_form.user_id = current_user.id
    @purchase_form.item_id = params[:item_id]
    @item = Item.find(@purchase_form.item_id)

   

    if @purchase_form.valid?
      #Payjp.api_key = "sk_test_9f81082858ec42095d7ffe7b" # PAY.JPテスト秘密鍵
      pay_item
      #item_price = @item.price
      #charge = Payjp::Charge.create(
        # amount: item_price, # 商品の金額情報を使用
        #card: @purchase_form.token, # カードトークン
        #currency: 'jpy'
      #)
  
      #if charge.paid
        # 購入処理が成功した場合の処理
        @purchase_form.save
       # @order = Order.create(user_id: current_user.id, item_id: @purchase_form.item_id)
        redirect_to root_path, notice: '購入が完了しました。'
      else
        # 購入処理が失敗した場合の処理
        #puts charge.failure_message
        #render :index, status: :unprocessable_entity
     
      # バリデーションエラーがある場合の処理
      #puts @purchase_form.errors.full_messages
      render :index, status: :unprocessable_entity
    end
  end
  private

  def purchase_params
    params.require(:purchase_form).permit(:user_id, :item_id, :postal_code, :prefecture, :city, :house_number, :building_name, :tel, :token).merge(user_id: current_user.id, item_id: params[:item_id], token: params[:token])
  end

  def pay_item
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    charge = Payjp::Charge.create(
      amount: @item.price, # 商品の金額情報を使用
      card: @purchase_form.token, # カードトークン
      currency: 'jpy'
    )
  end
end