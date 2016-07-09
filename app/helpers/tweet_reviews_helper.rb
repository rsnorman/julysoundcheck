module TweetReviewsHelper
  def rating_options
    Rating::RATINGS.to_a.inject({'-- Choose Rating --' => nil}) do |ratings, rating|
      ratings.merge("#{Rating::DESCRIPTIONS[rating.last]} (#{rating.first})" => rating.last)
    end
  end

  def group_albums_results(albums)
    grouped_albums = [[]]
    albums.each do |album|
      grouped_albums.last << album
      grouped_albums << [] if grouped_albums.last.size >= 3
    end
    grouped_albums
  end
end
