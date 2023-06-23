class OrdersController < ApplicationController
  def index
    @purchase_form = PurchaseForm.new
  end

  def create
    @purchase_form = PurchaseForm.new(purchase_params)
    if @purchase_form.save
      # 購入処理が成功した場合の処理
      redirect_to root_path, notice: '購入が完了しました。'
    else
      # 購入処理が失敗した場合の処理
      render :index
    end
  end

  private

  def purchase_params
    params.require(:purchase_form).permit(:user_id, :item_id, :postal_code, :prefecture, :city, :house_number, :building_name, :tel)
  end
end