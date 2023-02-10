class PayForm
  include ActiveModel::Model
  attr_accessor :item_id, :token, :postal_code, :prefecture, :city, :addresses, :building, :phone_number, :user_id

  # <<バリデーション>>
  with_options presence: true do
    validates :item_id
    validates :token, presence: { message: "can't be blank" }
    validates :postal_code, format: { with: /\A\d{3}[-]\d{4}\z/, message: 'is invalid. Enter it as follows (e.g. 123-4567)' }
    validates :prefecture, numericality: { other_than: 0, message: "can't be blank" }
    validates :city
    validates :addresses
    validates :phone_number
    validates :user_id
  end
  
  validates :phone_number, length: { minimum: 10, message: 'is too short' }
  validates :phone_number, length: { maximum: 11, message: 'is too long' }
  # 以下のように1つにまとめるのも良い（エラーメッセージは工夫の必要あり）
  # validates :phone_number, length: { in: 10..11, message: 'エラーメッセージ' }
  validates :phone_number, numericality: {message: 'is invalid. Input only number'}

  def save
    order = Order.create(
                          item_id: item_id,
                          user_id: user_id
                        )
    Address.create(
      order_id: order.id,
      postal_code: postal_code,
      prefecture: prefecture,
      city: city,
      addresses: addresses,
      building: building,
      phone_number: phone_number
    )
  end
end
