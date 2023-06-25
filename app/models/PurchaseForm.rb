class PurchaseForm
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :postal_code, :prefecture, :city, :house_number, :building_name, :tel

  validates :user_id, :item_id, :postal_code, :prefecture, :city, :house_number, presence: true
  validates :postal_code, presence: { message: '郵便番号を入力してください' }
  validates :prefecture, presence: { message: '都道府県を選択してください' }
  validates :city, presence: { message: '市区町村を入力してください' }
  validates :house_number, presence: { message: '番地を入力してください' }

  def save
    if valid?
      # 各テーブルにデータを保存する処理を書く
      ActiveRecord::Base.transaction do
      order = Order.create!(user_id: user_id, item_id: item_id)
      address = Address.create!(
        order_id: order.id,
        postal_code: postal_code,
        prefecture: prefecture,
        city: city,
        house_number: house_number,
        building_name: building_name,
        tel: tel,
      )
  
      # その他必要な処理を追加
      return order, address
    end
  else
    false
  end
end
end