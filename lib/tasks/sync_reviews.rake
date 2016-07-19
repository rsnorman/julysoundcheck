namespace :reviews do
  desc "Syncs reviews with Google Sheet"
  task sync: :environment do
    Archiver::TweetArchiver.archive
    SheetSync::Downloader.download
  end
end
