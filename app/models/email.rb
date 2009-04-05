class Email < ActiveRecord::Base
  set_primary_key "email"

  belongs_to :company

  validates_presence_of :email
end
