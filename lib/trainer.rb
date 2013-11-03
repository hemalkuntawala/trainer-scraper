class Trainer
  include Mongoid::Document
  
  field :external_id, type: Integer
  field :has_data, type: Boolean
  field :name, type: String
  field :gender, type: String
  field :age, type: Integer
  field :session_price, type: String
  field :phone_number, type: String
  field :member_since, type: String
  field :website, type: String
end
