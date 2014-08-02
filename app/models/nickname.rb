class Nickname < ActiveRecord::Base
  belongs_to :user

  scope :current, -> { where(updated_at: Date.today.beginning_of_day..Date.today.end_of_day) }
  scope :of_user, -> (user_id ) { where(user_id: user_id) }

  # The order of the validations is important
  # in this case we start with the fastest running and end with the most expensive calculation
  validates :name, presence: true
  validate  :only_one_nickname_per_day,
              :name_has_to_be_unique_per_user,
              :name_has_to_be_unique_per_day

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

  def name_has_to_be_unique_per_user
    # case insensitive comparison
    # downcasing a whole array comes with poor performance if it has many elements
    #   Nickname.current.pluck("name").map(&:downcase).include? name.downcase
    # might be ok, if run as nightly cron-job
    # this alternative might perform faster under specific cirumstances:
    #   Nickname.current.pluck("name").any?{ |nick| nick.casecmp(name) == 0 }
    # faster should be a direct SQL query
    if Nickname.of_user(user_id).where("LOWER(name) LIKE ?", name.downcase).first.present?
      errors.add(:name, "The nickname must be unique per user.")
    end
  end

  def only_one_nickname_per_day
    # could be written as without changing the SQL query
    #  Nickname.of_user(user_id).current.first.present?
    if user.nicknames.current.first.present?
      errors.add(:name, "User already has a nickname for today.")
    end
  end

end
