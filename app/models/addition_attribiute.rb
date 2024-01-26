class AdditionAttribiute < ApplicationRecord
  belongs_to :guest
  belongs_to :addition_attribiute_name
  
  validates :guest, :addition_attribiute_name, uniqueness: { scope: [:addition_attribiute_name, :guest] }, presence: true
  validates :value, presence: true, length: {maximum: 250}
end
