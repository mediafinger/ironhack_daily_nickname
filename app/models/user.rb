class User < ActiveRecord::Base
  has_many :nicknames

  validates :name, presence: true

  def nickname
    # this will break when nicknames.current returns nil
    nicknames.current.first.name

    # so either call:
    #   nicknames.current.first.try(:name)

    # or create a name if none is present
    #   nick = nicknames.current.first
    #   nick.present? ? nick.name : nicknames.create!(name: NameGeneratorService.new.generate).name
  end

  # run nicknames_in(...).explain BEFORE running the migration and AFTER adding the index
  def nicknames_in(start_date:, end_date:)
    nicknames.where(updated_at: start_date..end_date).order(:name)
  end
end
