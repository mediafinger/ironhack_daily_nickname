class Nickname < ActiveRecord::Base
  belongs_to :user

  scope :current, -> { where(updated_at: Date.today.beginning_of_day..Date.today.end_of_day) }

  validates :name, presence: true
  validate  :name_has_to_be_unique_per_day

  def name_has_to_be_unique_per_day
    if Nickname.current.pluck("name").include? name
      errors.add(:name, "The nickname must be unique per day.")
    end
  end

end
