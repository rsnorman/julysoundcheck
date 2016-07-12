namespace :reviews do
  desc "Syncs reviews with Google Sheet"
  task sync: :environment do
    SheetSync::Downloader.download
  end
end
