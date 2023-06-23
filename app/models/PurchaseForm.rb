class PurchaseForm
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :postal_code, :prefecture, :city, :house_number, :building_name, :tel

  validates :user_id, :item_id, :postal_code, :prefecture, :city, :house_number, presence: true

  def save
    if valid?
      # 各テーブルにデータを保存する処理を書く
      order = Order.create!(user_id: user_id, item_id: item_id)
      shipping_address = ShippingAddress.create!(
        order_id: order.id,
        postal_code: postal_code,
        prefecture: prefecture,
        city: city,
        house_number: house_number,
        building_name: building_name,
        tel: tel
      )
      # その他必要な処理を追加
    else
      false
    end
  end
end