class AlbumsController < ApplicationController
  layout false

  def index
    @albums = matching_albums
  end

  private

  def matching_albums
    RSpotify::Album.search(search_params.values.join(' ')).map do |album|
      Album.new(album)
    end
  end

  def search_params
    params.permit(:artist, :album)
  end
end
