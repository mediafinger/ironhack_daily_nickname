class Nickname < ActiveRecord::Base
  belongs_to :user

  validates :name, presence: true, uniqueness: {
    case_sensitive: false,
    message: "The nickname must be unique."
  }

  scope :current, -> { where(updated_at: Date.today.beginning_of_day..Date.today.end_of_day) }

end
