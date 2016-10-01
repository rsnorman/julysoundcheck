Given(/^review exists with "([^"]*)" listen URL$/) do |embed_type|
  @review = FactoryGirl.create(:review, embed_type.downcase.to_sym)
end

Then(/^I see the Bandcamp album embedded$/) do
  expect(@home_page.reviews.first.album_player).to have_embed_link(
    "https://bandcamp.com/EmbeddedPlayer/album=#{@review.album_source_id}"
  )
end

Then(/^I see the Soundcloud album embedded$/) do
  expect(@home_page.reviews.first.album_player).to have_embed_link(
    "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/playlists/#{@review.album_source_id}"
  )
end

Then(/^I see the Spotify album embedded$/) do
  expect(@home_page.reviews.first.album_player).to have_embed_link(
    "https://embed.spotify.com/?uri=spotify:album:#{@review.album_source_id}"
  )
end

Then(/^I see the Youtube album embedded$/) do
  expect(@home_page.reviews.first.album_player).to have_embed_link(
    "https://www.youtube.com/embed/#{@review.album_source_id}"
  )
end

Given(/^review exists with unknown listen URL$/) do
  @review = FactoryGirl.create(:review, :no_embed)
end

Then(/^I see the listen URL linked$/) do
  expect(@home_page.reviews.first).to have_link 'Listen', href: @review.listen_url
end
