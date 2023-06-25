class OrdersController < ApplicationController
  def index
    @purchase_form = PurchaseForm.new
    @item = Item.find(params[:item_id])
  end

  def create
    #binding.pry
    @purchase_form = PurchaseForm.new(purchase_params)
    @purchase_form.user_id = current_user.id
    @purchase_form.item_id = params[:item_id]
    if @purchase_form.save
      # 購入処理が成功した場合の処理
      @order = Order.create(user_id: current_user.id, item_id: @purchase_form.item_id)
      redirect_to root_path, notice: '購入が完了しました。'
    else
      # 購入処理が失敗した場合の処理
      @item = Item.find(params[:item_id])
      #redirect_to request.referrer, alert: '購入できませんでした。'
      puts @purchase_form.errors.full_messages
      render :index, status: :unprocessable_entity
    end
  end

  private

  def purchase_params
    params.require(:purchase_form).permit(:user_id, :item_id, :postal_code, :prefecture, :city, :house_number, :building_name, :tel).merge(user_id: current_user.id)
  end
end