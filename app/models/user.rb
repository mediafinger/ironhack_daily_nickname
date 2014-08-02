class User < ActiveRecord::Base
  has_many :nicknames

  validates :name, presence: true

  def nickname
    nicknames.current.first.name
  end
end
