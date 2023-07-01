class PurchaseForm
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :postal_code, :prefecture, :city, :house_number, :building_name, :tel, :token
 
  validates :user_id, :item_id, presence: true

  with_options presence: true do
    validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/, message: '郵便番号を正しい形式で入力してください' }
    validates :prefecture, exclusion: { in: ['---'], message: '都道府県を選択してください' }
    validates :city, presence: { message: '市区町村を入力してください' }
    validates :house_number, presence: { message: '番地を入力してください' }
    validates :tel, format: { with: /\A\d{10,11}\z/, message: '電話番号は10桁以上11桁以内の半角数値で入力してください' }
    validates :token, presence: { message: 'クレジットカード情報を入力してください' }
  end
  def save
    
      # 各テーブルにデータを保存する処理を書く
   
      order = Order.create(user_id: user_id, item_id: item_id)
      address = Address.create(
        order_id: order.id,
        postal_code: postal_code,
        prefecture: prefecture,
        city: city,
        house_number: house_number,
        building_name: building_name,
        tel: tel,
      )
    
end
end