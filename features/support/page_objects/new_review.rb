class NewReview < SitePrism::Page
  set_url "tweets/{tweet_id}/tweet_reviews/new"

  def set_artist(artist)
    fill_in 'Artist', with: artist
  end

  def set_album(album)
    fill_in 'Album', with: album
  end

  def set_genre(genre)
    fill_in 'Genre', with: genre
  end

  def set_listen_url(listen_url)
    fill_in 'Listen url', with: listen_url
  end

  def set_as_album_of_the_month
    check 'Album of the month'
  end

  def create
    click_button 'Create Tweet Review'
  end
end
