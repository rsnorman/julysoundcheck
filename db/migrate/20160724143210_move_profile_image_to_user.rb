class MoveProfileImageToUser < ActiveRecord::Migration[5.0]
  class MigrateUser < ActiveRecord::Base
    self.table_name = :users
    has_many :tweets, class_name: 'MigrateTweet'
  end

  class MigrateTweet < ActiveRecord::Base
    self.table_name = :tweets
  end

  def up
    add_column :users, :profile_image_uri, :string

    MigrateTweet.pluck(:user_id, :profile_image_uri)
      .uniq
      .each do |user_id, profile_image_uri|
        User.find(user_id).update(profile_image_uri: profile_image_uri)
      end

    remove_column :tweets, :profile_image_uri, :string
  end

  def down
    add_column :tweets, :profile_image_uri, :string

    MigrateUser.all.includes(:tweets) do |user|
      user.tweets.update_all(profile_image_uri: user.profile_image_uri)
    end

    remove_column :users, :profile_image_uri, :string
  end
end
