namespace :tweets do
  desc "Downloads old tweets"
  task download_old: :environment do
    Archiver::OldTweetArchiver.archive
  end
end
