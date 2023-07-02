class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:index, :create]
  before_action :check_purchase_status, only: [:index]
  before_action :set_public_key, only: [:index, :create]

  def index
    @purchase_form = PurchaseForm.new
    redirect_to root_path if @item.order&.exists? || current_user.id == @item.user_id
  end

  def create
    @purchase_form = PurchaseForm.new(purchase_params)
    

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
    params.require(:purchase_form).permit(:postal_code, :prefecture, :city, :house_number, :building_name, :tel, :token).merge(user_id: current_user.id, item_id: params[:item_id], token: params[:token])    
  end
  
  def pay_item
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    charge = Payjp::Charge.create(
      amount: @item.price, # 商品の金額情報を使用
      card: @purchase_form.token, # カードトークン
      currency: 'jpy'
    )
  end

  def check_purchase_status
    return unless @item.purchased?
    redirect_to root_path, alert: '購入済みの商品の購入ページにはアクセスできません。'
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def set_public_key
    gon.public_key = ENV["PAYJP_PUBLIC_KEY"]
  end
  
end
