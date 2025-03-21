class User < ApplicationRecord
  validations :username, presence: true, :email, presence: true
end