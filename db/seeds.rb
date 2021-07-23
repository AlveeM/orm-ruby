class Seed 
  def self.seed_data
    10.times do
      Quote.create(
        author: "Michael Scott",
        content: Faker::TvShows::MichaelScott.quote
      )
    end

    10.times do
      Quote.create(
        author: "Yoda",
        content: Faker::Quote.yoda
      )
    end
  end
end