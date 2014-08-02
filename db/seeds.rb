USERS = 10
DAYS  = 365

usernames = NameGeneratorService.new(5)
nicknames = NameGeneratorService.new(12)

(1..USERS).each do
  user = User.create(name: usernames.generate)

  missed_days = []
  (1..DAYS).each do |index|
    begin
      user.nicknames.create!(name: nicknames.generate, updated_at: Date.today - index.days)
    rescue ActiveRecord::RecordInvalid
      missed_days << index
    end
  end
  puts "User #{user.id} has no nicknames for #{missed_days}" unless missed_days.blank?
end
