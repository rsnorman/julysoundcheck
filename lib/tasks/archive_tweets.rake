namespace :tweets do
  desc "Archive new tweets"
  task archive: :environment do
    Archiver::TweetArchiver.archive
  end

  desc "Downloads old tweets"
  task download_old: :environment do
    Archiver::OldTweetArchiver.archive
  end

  desc "Create users from tweets"
  task create_users: :environment do
    Archiver::TweetUserCreator.create
  end
end
