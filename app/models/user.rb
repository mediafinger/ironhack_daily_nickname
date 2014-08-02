class User < ActiveRecord::Base
  validates :name,           presence: true
  validates :daily_nickname, presence: true, uniqueness: true
end
