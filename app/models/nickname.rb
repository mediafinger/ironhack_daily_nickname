class Nickname < ActiveRecord::Base
  belongs_to :user

  scope :current, -> { where(updated_at: Date.today.beginning_of_day..Date.today.end_of_day) }

  validates :name, presence: true
  validate  :name_has_to_be_unique_per_day

  def name_has_to_be_unique_per_day
    # case insensitive comparison
    # downcasing a whole array comes with poor performance if it has many elements
    #   Nickname.current.pluck("name").map(&:downcase).include? name.downcase
    # might be ok, if run as nightly cron-job
    # this alternative might perform faster under specific cirumstances:
    #   Nickname.current.pluck("name").any?{ |nick| nick.casecmp(name) == 0 }
    # faster should be a direct SQL query
    if Nickname.current.where("LOWER(name) LIKE ?", name.downcase).first.present?
      errors.add(:name, "The nickname must be unique per day.")
    end
  end

end
