module TweetReviewsHelper
  def rating_options
    Rating::SCORES.to_a.inject({'-- Choose Rating --' => nil}) do |ratings, rating|
      ratings.merge("#{Rating::DESCRIPTIONS[rating.last]} (#{rating.first})" => rating.last)
    end
  end

  def rating_group_links
    Rating::SCORE_GROUPS.inject([]) do |links, (group, description)|
      links + ["<li>#{link_to description, ratings_path(group)}</li>"]
    end.reverse.join.html_safe
  end

  def rating_group_description(rating_group)
    Rating::SCORE_GROUPS[rating_group.to_i]
  end

  def group_albums_results(albums)
    grouped_albums = [[]]
    albums.each do |album|
      grouped_albums.last << album
      grouped_albums << [] if grouped_albums.last.size >= 3
    end
    grouped_albums.delete([])
    grouped_albums
  end
end
