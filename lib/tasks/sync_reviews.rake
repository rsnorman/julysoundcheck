namespace :reviews do
  desc "Syncs reviews with Google Sheet"
  task sync: :environment do
    SheetSyncer.new.sync
  end
end
