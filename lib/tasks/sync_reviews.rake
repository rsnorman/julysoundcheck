namespace :reviews do
  desc 'Syncs reviews with Google Sheet'
  task sync: :environment do
    Archiver::TweetArchiver.archive
    puts 'Start syncing to sheet'
    SheetSync::Download::SheetReader.download
    puts 'Finshed syncing sheet successfully'
  end
end
