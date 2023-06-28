class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:index, :create]

  def index
    @purchase_form = PurchaseForm.new
    @item = Item.find(params[:item_id])
    redirect_to root_path, alert: '既に購入済みの商品です。' if @item.purchased?
  end

  def create
    @purchase_form = PurchaseForm.new(purchase_params)
    @purchase_form.user_id = current_user.id
    @purchase_form.item_id = params[:item_id]
    @item = Item.find(@purchase_form.item_id)

   

    if @purchase_form.valid?
      pay_item
        @purchase_form.save
        redirect_to root_path, notice: '購入が完了しました。'
      else
      render :index, status: :unprocessable_entity
    end
  end
  private

  def purchase_params
  postal_code = params[:purchase_form][:postal_code]
  # 郵便番号の形式を正規表現でチェックする
  if postal_code.match(/\A\d{3}-\d{4}\z/)
    params.require(:purchase_form).permit(:user_id, :item_id, :postal_code, :prefecture, :city, :house_number, :building_name, :tel, :token).merge(user_id: current_user.id, item_id: params[:item_id], token: params[:token])
  else
    # 郵便番号の形式が不正な場合はエラーメッセージを追加して不正な値を弾く
    params.require(:purchase_form).permit!.tap do |whitelisted|
      whitelisted[:postal_code] = nil
    end
  end
end

  def pay_item
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    charge = Payjp::Charge.create(
      amount: @item.price, # 商品の金額情報を使用
      card: @purchase_form.token, # カードトークン
      currency: 'jpy'
    )
  end

  
  def set_item
    @item = Item.find(params[:item_id])
  end

  def authenticate_user!
    unless user_signed_in?
      redirect_to new_user_session_path, alert: 'ログインが必要です'
    end
  end
end