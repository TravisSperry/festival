class Admin < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :registerable
end
