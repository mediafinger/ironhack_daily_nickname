class NameGeneratorService
  attr_reader :length

  def initialize(length = 5)
    @length = length
  end

  # this stupid but simple generator is enough for development
  # for better names we could enhance this method without changing the seeds script
  # we could also use something like the "Faker" gem
  def generate
    ('a'..'z').to_a.shuffle[0, length].join.capitalize
  end
end
